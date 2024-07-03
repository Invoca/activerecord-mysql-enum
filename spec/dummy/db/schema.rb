# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2020_10_22_210055) do
  create_table "basic_default_enum_test_models", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.column "value", "enum('good','working')", limit: [:good, :working], default: :working
  end

  create_table "basic_enum_test_models", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.column "value", "enum('good','working')", limit: [:good, :working]
  end

  create_table "enumeration_test_models", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.column "severity", "enum('low','medium','high','critical')", limit: [:low, :medium, :high, :critical], default: :medium
    t.column "color", "enum('red','blue','green','yellow')", limit: [:red, :blue, :green, :yellow]
    t.string "string_field", limit: 8, null: false
    t.integer "int_field"
  end

  create_table "nonnull_default_enum_test_models", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.column "value", "enum('good','working')", limit: [:good, :working], default: :working, null: false
  end

  create_table "nonnull_enum_test_models", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.column "value", "enum('good','working')", limit: [:good, :working], null: false
  end

end
