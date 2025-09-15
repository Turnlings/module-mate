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

ActiveRecord::Schema[7.2].define(version: 2025_09_15_132207) do
  create_table "exam_results", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "exam_id", null: false
    t.decimal "score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exam_id"], name: "index_exam_results_on_exam_id"
    t.index ["user_id"], name: "index_exam_results_on_user_id"
  end

  create_table "exams", force: :cascade do |t|
    t.decimal "weight"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "uni_module_id", null: false
    t.string "type"
    t.datetime "due"
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

  create_table "semesters", force: :cascade do |t|
    t.string "name"
    t.integer "year_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "share_token"
    t.index ["share_token"], name: "index_semesters_on_share_token", unique: true
    t.index ["year_id"], name: "index_semesters_on_year_id"
  end

  create_table "semesters_uni_modules", id: false, force: :cascade do |t|
    t.integer "semester_id", null: false
    t.integer "uni_module_id", null: false
    t.index ["semester_id", "uni_module_id"], name: "index_semesters_uni_modules_on_semester_id_and_uni_module_id"
    t.index ["uni_module_id", "semester_id"], name: "index_semesters_uni_modules_on_uni_module_id_and_semester_id"
  end

  create_table "timelogs", force: :cascade do |t|
    t.integer "uni_module_id", null: false
    t.integer "minutes"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.date "date"
    t.index ["uni_module_id"], name: "index_timelogs_on_uni_module_id"
    t.index ["user_id"], name: "index_timelogs_on_user_id"
  end

  create_table "uni_module_targets", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "uni_module_id", null: false
    t.decimal "score"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uni_module_id"], name: "index_uni_module_targets_on_uni_module_id"
    t.index ["user_id"], name: "index_uni_module_targets_on_user_id"
  end

  create_table "uni_modules", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "credits"
    t.decimal "target"
    t.boolean "pinned", default: false
  end

  create_table "users", force: :cascade do |t|
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "provider"
    t.string "uid"
    t.string "email"
    t.datetime "terms_of_service_agreed_at"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "years", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.float "weighting"
    t.index ["user_id"], name: "index_years_on_user_id"
  end

  add_foreign_key "exam_results", "exams"
  add_foreign_key "exam_results", "users"
  add_foreign_key "exams", "uni_modules"
  add_foreign_key "gradeds", "uni_modules"
  add_foreign_key "semesters", "years"
  add_foreign_key "timelogs", "uni_modules"
  add_foreign_key "timelogs", "users"
  add_foreign_key "uni_module_targets", "uni_modules"
  add_foreign_key "uni_module_targets", "users"
  add_foreign_key "years", "users"
end
