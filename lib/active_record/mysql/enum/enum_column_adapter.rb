# frozen_string_literal: true

# This module provides all the column helper methods to deal with the
# values and adds the common type management code for the adapters.

module ActiveRecord
  module Mysql
    module Enum

      class << self
        def mysql_column_adapter
          if defined? ActiveRecord::ConnectionAdapters::Mysql2Adapter::Column
            ActiveRecord::ConnectionAdapters::Mysql2Adapter::Column
          elsif defined? ActiveRecord::ConnectionAdapters::MySQL::Column
            ActiveRecord::ConnectionAdapters::MySQL::Column
          else
            raise "could not find MySQL::Column or equivalent connection adapter"
          end
        end
      end

      ActiveRecordColumnWithEnums = Enum.mysql_column_adapter

      module EnumColumnAdapter
        def initialize(*)
          super

          if type == :enum
            @default = if @default.present?
                         @default.to_sym
                       end
          end
        end

        # Convert to a symbol.
        def type_cast_from_database(value)
          if type == :enum
            EnumColumnAdapter.value_to_symbol(value)
          else
            super
          end
        end

        class << self
          # Safely convert the value to a symbol.
          def value_to_symbol(value)
            case value
            when Symbol
              value
            when String
              value.to_sym if value.present?
            end
          end
        end
      end

      ActiveRecordColumnWithEnums.prepend EnumColumnAdapter
    end
  end
end
