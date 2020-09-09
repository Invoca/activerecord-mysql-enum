# frozen_string_literal: true

describe ActiveRecord::Mysql::Enum::MysqlAdapter do
  let(:db_connection) { ActiveRecord::Base.connection }

  context "#native_database_types" do
    it "returned types include enum" do
      db_types = db_connection.native_database_types

      expect(db_types).not_to be_empty
      expect(db_types[:enum]).to eq({ name: "enum" })
    end
  end

  context "#type_to_sql" do
    let(:expected_enum_sql_type) { "enum('a','b','c')" }

    if Rails::VERSION::MAJOR < 5
      it "supports enums" do
        sql_type = db_connection.type_to_sql('enum', [:a, :b, :c])
        expect(sql_type).to eq(expected_enum_sql_type)
      end

      it "calls super when not an enum" do
        sql_type = db_connection.type_to_sql('integer')
        expect(sql_type).to eq("int(11)")
      end
    else
      it "supports enums" do
        sql_type = db_connection.type_to_sql('enum', limit: [:a, :b, :c])
        expect(sql_type).to eq(expected_enum_sql_type)
      end

      it "calls super when not an enum" do
        sql_type = db_connection.type_to_sql('integer')
        expect(sql_type).to eq("int")
      end
    end
  end
end