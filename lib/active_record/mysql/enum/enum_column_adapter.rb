# frozen_string_literal: true

# This module provides all the column helper methods to deal with the
# values and adds the common type management code for the adapters.

module ActiveRecord
  module Mysql
    module Enum
      module EnumColumnAdapter
        def initialize(*)
          super

          if type == :enum
            @default = if @default.present?
                         @default.to_sym
                       end
          end
        end
      end
    end
  end
end

column_class = if defined? ActiveRecord::ConnectionAdapters::Mysql2Adapter::Column
                 ActiveRecord::ConnectionAdapters::Mysql2Adapter::Column
               elsif defined? ActiveRecord::ConnectionAdapters::MySQL::Column
                 ActiveRecord::ConnectionAdapters::MySQL::Column
               else
                 raise "could not find MySQL::Column or equivalent connection adapter"
               end

if column_class
  column_class.class_eval do
    prepend ActiveRecord::Mysql::Enum::EnumColumnAdapter

    def __enum_type_cast(value)
      if type == :enum
        self.class.value_to_symbol(value)
      else
        __type_cast_enum(value)
      end
    end

    if instance_methods.include?(:type_cast_from_database)
      alias __type_cast_enum type_cast_from_database
      # Convert to a symbol.
      def type_cast_from_database(value)
        __enum_type_cast(value)
      end
    elsif instance_methods.include?(:type_cast)
      alias __type_cast_enum type_cast
      def type_cast(value)
        __enum_type_cast(value)
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
        else
          nil
        end
      end
    end
  end
end
