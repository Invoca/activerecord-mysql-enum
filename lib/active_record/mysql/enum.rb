# frozen_string_literal: true

if defined?(::Rails::Railtie)
  module ActiveRecord
    module Mysql
      module Enum
        class Railtie < Rails::Railtie
          initializer 'active_record-mysql-enum.initialize', :after => 'active_record.initialize_database' do |app|
            ActiveSupport.on_load :active_record do
              require 'active_record/mysql/enum/mysql_adapter'
              require 'active_record/mysql/enum/enum_type'
              require 'active_record/mysql/enum/enum_adapter'
              require 'active_record/mysql/enum/enum_column_adapter'
              require 'active_record/mysql/enum/schema_definitions'
              require 'active_record/mysql/enum/quoting'
              require 'active_record/mysql/enum/validations'
            end
          end
        end
      end
    end
  end
end
