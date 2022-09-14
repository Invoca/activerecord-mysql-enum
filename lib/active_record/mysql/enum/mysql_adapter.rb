# frozen_string_literal: true

module ActiveRecord
  module Mysql
    module Enum

      class << self
        def mysql_adapter
          defined? ActiveRecord::ConnectionAdapters::Mysql2Adapter or raise "Could not find MySQL connection adapter"

          ActiveRecord::ConnectionAdapters::Mysql2Adapter
        end

        def register_enum_with_type_mapping(m)
          m.register_type(/enum/i) do |sql_type|
            limit = sql_type.sub(/^enum\('(.+)'\)/i, '\1').split("','").map { |v| v.to_sym }
            ActiveRecord::Type::Enum.new(limit: limit)
          end
        end
      end

      ActiveRecordMysqlAdapter = Enum.mysql_adapter

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

        if Gem::Version.new(ActiveRecord.version) < Gem::Version.new('7.0')
          private

          def initialize_type_map(m = type_map)
            super

            Enum.register_enum_with_type_mapping(m)
          end
        end
      end

      ActiveRecordMysqlAdapter.prepend ActiveRecord::Mysql::Enum::MysqlAdapter

      unless Gem::Version.new(ActiveRecord.version) < Gem::Version.new('7.0')
        [ActiveRecordMysqlAdapter::TYPE_MAP, ActiveRecordMysqlAdapter::TYPE_MAP_WITH_BOOLEAN].each do |m|
          Enum.register_enum_with_type_mapping(m)
        end
      end
    end
  end
end
