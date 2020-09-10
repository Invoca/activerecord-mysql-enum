# frozen_string_literal: true

describe ActiveRecord::Mysql::Enum::EnumColumnAdapter do
  let(:test_column) { ActiveRecord::Mysql::Enum::ActiveRecordColumnWithEnums.new("test column", "default", column_type) }

  context "as an Enum column" do
    let(:column_type) { ActiveRecord::Type::Enum.new }

    it "creates a new Column" do
      expect(test_column).to be_a ActiveRecord::Mysql::Enum::ActiveRecordColumnWithEnums
    end

    if Rails::VERSION::MAJOR < 5
      context "#type_cast_from_database" do
        it "converts strings to symbols" do
          expect(test_column.type_cast_from_database("pizza")).to eq(:pizza)
        end

        it "leaves symbols as symbols" do
          expect(test_column.type_cast_from_database(:pizza)).to eq(:pizza)
        end

        it "returns nil for other data types" do
          [
            1,
            1.5,
            Time.now,
            true,
            ["fun"],
            { pizza: 'party' }
          ].each do |value|
            expect(test_column.type_cast_from_database(value)).to be nil
          end
        end
      end
    end
  end

  context "as a String column (calling super)" do
    let(:column_type) { ActiveRecord::Type::String.new }

    it "creates a new Column" do
      expect(test_column).to be_a ActiveRecord::Mysql::Enum::ActiveRecordColumnWithEnums
    end

    if Rails::VERSION::MAJOR < 5
      context "#type_cast_from_database" do
        it "leaves strings as strings" do
          expect(test_column.type_cast_from_database("pizza")).to eq("pizza")
        end

        it "converts symbols to strings" do
          expect(test_column.type_cast_from_database(:pizza)).to eq("pizza")
        end
      end
    end
  end
end
