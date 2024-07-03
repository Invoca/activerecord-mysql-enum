class AddNoneSeverityOption < (Rails::VERSION::MAJOR >= 5 ? ActiveRecord::Migration[4.2] : ActiveRecord::Migration)
  def self.up
    change_column :enumeration_test_models, :severity, :enum, limit: [:low, :medium, :high, :critical], default: :medium
  end

  def self.down
    change_column :enumeration_test_models, :severity, :enum, limit: [:none, :low, :medium, :high, :critical], default: :medium
  end
end
