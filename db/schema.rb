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

ActiveRecord::Schema[7.1].define(version: 2024_08_08_021128) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "boards", force: :cascade do |t|
    t.integer "attempts_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cells", force: :cascade do |t|
    t.bigint "generation_id", null: false
    t.integer "y", null: false
    t.integer "x", null: false
    t.boolean "alive", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["generation_id", "x", "y"], name: "index_cells_on_generation_id_and_x_and_y", unique: true
    t.index ["generation_id"], name: "index_cells_on_generation_id"
  end

  create_table "generations", force: :cascade do |t|
    t.bigint "board_id", null: false
    t.integer "generation_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["board_id", "generation_number"], name: "index_generations_on_board_id_and_generation_number", unique: true
    t.index ["board_id"], name: "index_generations_on_board_id"
  end

  add_foreign_key "cells", "generations"
  add_foreign_key "generations", "boards"
end
