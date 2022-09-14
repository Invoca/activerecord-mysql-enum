# frozen_string_literal: true

describe ActiveRecord::ConnectionAdapters::TableDefinition do
  context "supports defining new column type" do

    let(:column_name) { "enum_column_test" }
    let(:test_table_definition) do
      if ActiveRecord::VERSION::MAJOR < 6
        ActiveRecord::ConnectionAdapters::TableDefinition.new("test_table")
      else
        ActiveRecord::ConnectionAdapters::TableDefinition.new(ActiveRecord::Base.connection, "test_table")
      end
    end
    let(:column_options) do
      {
        limit: [:low, :medium, :high, :critical],
        default: :medium
      }
    end

    subject do
      test_table_definition.enum(column_name, column_options)
      test_table_definition[column_name]
    end

    it "#enum" do
      expect(subject.type).to eq(:enum)
      expect(subject.limit).to eq(column_options[:limit])
      expect(subject.default).to eq(column_options[:default])
    end
  end
end
