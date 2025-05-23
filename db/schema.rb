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

ActiveRecord::Schema[7.1].define(version: 2025_05_23_181714) do
  create_table "exams", force: :cascade do |t|
    t.decimal "weight"
    t.string "name"
    t.decimal "score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "uni_module_id", null: false
    t.index ["uni_module_id"], name: "index_exams_on_uni_module_id"
  end

  create_table "gradeds", force: :cascade do |t|
    t.decimal "weighting"
    t.decimal "score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "uni_module_id", null: false
    t.index ["uni_module_id"], name: "index_gradeds_on_uni_module_id"
  end

  create_table "timelogs", force: :cascade do |t|
    t.integer "uni_module_id", null: false
    t.integer "minutes"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uni_module_id"], name: "index_timelogs_on_uni_module_id"
  end

  create_table "uni_modules", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "exams", "uni_modules"
  add_foreign_key "gradeds", "uni_modules"
  add_foreign_key "timelogs", "uni_modules"
end
