class CreateSchema < (Rails::VERSION::MAJOR >= 5 ? ActiveRecord::Migration[4.2] : ActiveRecord::Migration)
  def self.up
    create_table :enumeration_test_models do |t|
      t.enum :severity, limit: [:none, :low, :medium, :high, :critical], default: :medium
      t.enum :color, limit: [:red, :blue, :green, :yellow]
      t.string :string_field, limit: 8, null: false
      t.integer :int_field
    end

    create_table :basic_enum_test_models do |t|
      t.enum :value, limit: [:good, :working]
    end

    create_table :basic_default_enum_test_models do |t|
      t.enum :value, limit: [:good, :working], default: :working
    end

    create_table :nonnull_enum_test_models do |t|
      t.enum :value, limit: [:good, :working], null: false
    end

    create_table :nonnull_default_enum_test_models do |t|
      t.enum :value, limit: [:good, :working], null: false, default: :working
    end
  end

  def self.down
    drop_table :enumeration
    drop_table :basic_enum_test_models
    drop_table :basic_default_enum_test_models
    drop_table :nonnull_enum_test_models
    drop_table :nonnull_default_enum_test_models
  end
end
