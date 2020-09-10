# frozen_string_literal: true

module ActiveRecord
  module Mysql
    module Enum

      class << self
        def current_mysql_adapter
          if defined? ActiveRecord::ConnectionAdapters::Mysql2Adapter
            ActiveRecord::ConnectionAdapters::Mysql2Adapter
          else
            raise "Could not find MySQL connection adapter"
          end
        end
      end

      ActiveRecordMysqlAdapter = Enum.current_mysql_adapter

      module MysqlAdapter
        def native_database_types #:nodoc
          types = super
          types[:enum] = { :name => "enum" }
          types
        end

        # Add enumeration support for schema statement creation. This
        # will have to be adapted for every adapter if the type requires
        # anything by a list of allowed values. The overrides the standard
        # type_to_sql method and chains back to the default. This could
        # be done on a per adapter basis, but is generalized here.
        #
        # will generate enum('a', 'b', 'c') for :limit => [:a, :b, :c]
        if Rails::VERSION::MAJOR < 5
          def type_to_sql(type, limit = nil, *args)
            if type.to_s == 'enum'
              column_type_sql =
                if (native_database_type = native_database_types[type])
                  native_database_type[:name]
                else
                  'enum'
                end

              quoted_values = limit.map { |v| quote(v) }.join(',')

              "#{column_type_sql}(#{quoted_values})"
            else
              super
            end
          end
        else
          def type_to_sql(type, limit: nil, **_options) # :nodoc:
            if type.to_s == 'enum'
              column_type_sql =
                if (native_database_type = native_database_types[type])
                  native_database_type[:name]
                else
                  'enum'
                end

              quoted_values = limit.map { |v| quote(v) }.join(',')

              "#{column_type_sql}(#{quoted_values})"
            else
              super
            end
          end
        end


        private

        def initialize_type_map(m = type_map)
          super

          m.register_type(/enum/i) do |sql_type|
            limit = sql_type.sub(/^enum\('(.+)'\)/i, '\1').split("','").map { |v| v.to_sym }
            ActiveRecord::Type::Enum.new(limit: limit)
          end
        end
      end

      ActiveRecordMysqlAdapter.prepend ActiveRecord::Mysql::Enum::MysqlAdapter
    end
  end
end
