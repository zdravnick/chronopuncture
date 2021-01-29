# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_01_29_134344) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "branches", force: :cascade do |t|
    t.integer "serial_number"
    t.string "name", limit: 255
    t.integer "active_hour_offset"
    t.string "own_element", limit: 255
    t.string "animal", limit: 255
    t.string "alias_ru", limit: 255
    t.string "alias_ch", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "day_meridian_id"
  end

  create_table "chinese_disease_element_influences", force: :cascade do |t|
    t.bigint "chinese_disease_id", null: false
    t.bigint "element_id", null: false
    t.integer "influence"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chinese_disease_id"], name: "idx_16612_index_chinese_disease_element_influences_on_chinese_d"
    t.index ["element_id"], name: "idx_16612_index_chinese_disease_element_influences_on_element_i"
  end

  create_table "chinese_diseases", force: :cascade do |t|
    t.string "name", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "chinese_diseases_patients", force: :cascade do |t|
    t.bigint "patient_id", null: false
    t.bigint "chinese_disease_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "kind", limit: 255
    t.index ["chinese_disease_id"], name: "idx_16624_index_chinese_diseases_patients_on_chinese_disease_id"
    t.index ["patient_id"], name: "idx_16624_index_chinese_diseases_patients_on_patient_id"
  end

  create_table "cities", force: :cascade do |t|
    t.string "name", limit: 255
    t.float "lng"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "time_zone", limit: 255, default: "UTC"
    t.float "lat"
  end

  create_table "doctors", force: :cascade do |t|
    t.string "name", limit: 255
    t.string "email", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "moderator", default: false
    t.date "birthday"
    t.boolean "banned", default: false
    t.string "avatar", limit: 255
    t.string "encrypted_password", limit: 255, default: "", null: false
    t.string "reset_password_token", limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "city_id"
    t.string "phone", limit: 255
    t.datetime "paid_until"
    t.index ["email"], name: "idx_16640_index_doctors_on_email", unique: true
    t.index ["name"], name: "idx_16640_index_doctors_on_name", unique: true
    t.index ["reset_password_token"], name: "idx_16640_index_doctors_on_reset_password_token", unique: true
  end

  create_table "elements", force: :cascade do |t|
    t.string "name", limit: 255
    t.string "yin_yang", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "wu_xing_meridian_id"
    t.integer "season_meridian_first_id"
    t.integer "trunk_meridian_id"
    t.integer "season_meridian_second_id"
    t.string "alias_ru"
  end

  create_table "layers", force: :cascade do |t|
    t.string "name", limit: 255
    t.string "leg_meridian_name", limit: 255
    t.string "arm_meridian_name", limit: 255
    t.string "leg_meridian_element", limit: 255
    t.string "arm_meridian_element", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "leg_meridian_id", default: 0, null: false
    t.integer "arm_meridian_id", default: 0, null: false
    t.string "element_ke", limit: 255
    t.integer "own_element_id"
    t.string "alias_ru"
    t.index ["name"], name: "idx_16661_index_layers_on_name"
  end

  create_table "lines", force: :cascade do |t|
    t.string "yin_yang"
    t.string "age"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "dotted_solid"
    t.integer "point_id"
    t.integer "trigram_id"
  end

  create_table "meridians", force: :cascade do |t|
    t.string "name", limit: 255
    t.string "energy_name", limit: 255
    t.string "element_trunk", limit: 255
    t.string "element_branch", limit: 255
    t.string "element_ke", limit: 255
    t.string "alias_ru", limit: 255
    t.string "short_name_en", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "strong_nutrition_wu_xin_point_id"
    t.integer "weak_nutrition_wu_xin_point_id"
    t.integer "strong_nutrition_season_point_id"
    t.integer "weak_nutrition_season_point_id"
  end

  create_table "patients", force: :cascade do |t|
    t.string "name", limit: 255
    t.datetime "birthdate"
    t.integer "doctor_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "diagnosis", limit: 255
    t.text "description"
    t.integer "city_id"
    t.index ["doctor_id"], name: "idx_16681_index_patients_on_doctor_id"
  end

  create_table "points", force: :cascade do |t|
    t.string "name", limit: 255
    t.string "alias_en", limit: 255
    t.string "alias_ru", limit: 255
    t.string "alias_cn", limit: 255
    t.string "own_element", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "own_element_id"
    t.integer "meridian_id"
    t.integer "serial_number"
    t.string "function", limit: 255
    t.string "big_nutrition_point", limit: 255
    t.string "small_nutrition_point", limit: 255
    t.index ["name"], name: "idx_16690_index_points_on_name"
  end

  create_table "trigrams", force: :cascade do |t|
    t.string "name"
    t.string "alias_ru"
    t.string "alias_cn"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "line_1_id"
    t.integer "line_2_id"
    t.integer "line_3_id"
  end

  create_table "trunks", force: :cascade do |t|
    t.string "name", limit: 255
    t.string "serial_number", limit: 255
    t.string "trunk_energy", limit: 255
    t.integer "year_meridian_id"
    t.integer "day_meridian_id"
    t.string "alias_ru", limit: 255
    t.string "alias_ch", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "forbidden_action_by_days"
  end

  create_table "visits", force: :cascade do |t|
    t.datetime "visited_at"
    t.string "treatment", limit: 255
    t.integer "patient_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "visit_description"
    t.index ["patient_id"], name: "idx_16720_index_visits_on_patient_id"
  end

  add_foreign_key "chinese_disease_element_influences", "chinese_diseases"
  add_foreign_key "chinese_disease_element_influences", "elements"
  add_foreign_key "chinese_diseases_patients", "chinese_diseases"
  add_foreign_key "chinese_diseases_patients", "patients"
end
