# frozen_string_literal: true

require_relative '../helpers/test_const_overrides'

describe ActiveRecord::Mysql::Enum::MysqlAdapter do
  include ConstantOverrides::TestConstOverride

  context "adapter not found" do
    before do
      if defined? ActiveRecord::ConnectionAdapters::Mysql2Adapter
        unset_test_const("ActiveRecord::ConnectionAdapters::Mysql2Adapter")
      end
    end

    after do
      cleanup_constant_overrides
    end

    it "raises" do
      expect { ActiveRecord::Mysql::Enum.mysql_adapter }.to raise_error(RuntimeError, "Could not find MySQL connection adapter")
    end
  end

  let(:db_connection) { ActiveRecord::Base.connection }

  context "#native_database_types" do
    it "returned types include enum" do
      db_types = db_connection.native_database_types

      expect(db_types).not_to be_empty
      expect(db_types[:enum]).to eq({ name: "enum" })
    end
  end

  context "#type_to_sql" do
    def version_safe_type_to_sql(type, limit)
      db_connection.type_to_sql(type, limit: limit)
    end

    let(:expected_enum_sql_type) { "enum('a','b','c')" }

    it "supports enums" do
      sql_type = version_safe_type_to_sql('enum', [:a, :b, :c])
      expect(sql_type).to eq(expected_enum_sql_type)
    end

    it "calls super when not an enum" do
      sql_type = version_safe_type_to_sql('integer', 1)
      expect(sql_type).to eq("tinyint")
    end

    it "returns the native enum type if already set" do
      sql_type = version_safe_type_to_sql('enum', [:a, :b, :c])
      expect(sql_type).to eq(expected_enum_sql_type)

      sql_type = version_safe_type_to_sql('enum', [:a, :b, :c])
      expect(sql_type).to eq(expected_enum_sql_type)
    end
  end
end
