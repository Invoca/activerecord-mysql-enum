# frozen_string_literal: true

require 'active_record'
require_relative '../../lib/active_record/mysql/enum/validations'

class EnumerationTestModel < ActiveRecord::Base
  validates_columns :color, :severity, :string_field, :int_field
end

class BasicEnumTestModel < ActiveRecord::Base
  validates_columns :value
end

class BasicDefaultEnumTestModel < ActiveRecord::Base
  validates_columns :value
end

class NonnullEnumTestModel < ActiveRecord::Base
  validates_columns :value
end

class NonnullDefaultEnumTestModel < ActiveRecord::Base
  validates_columns :value
end
