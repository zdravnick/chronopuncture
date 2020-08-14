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

ActiveRecord::Schema.define(version: 2020_07_14_184150) do

  create_table "branches", force: :cascade do |t|
    t.integer "serial_number"
    t.string "name"
    t.integer "active_hour_offset"
    t.string "own_element"
    t.string "animal"
    t.string "alias_ru"
    t.string "alias_ch"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "day_meridian_id"
  end

  create_table "cities", force: :cascade do |t|
    t.string "name"
    t.float "lng"

    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "time_zone", default: "UTC"
    t.float "lat"

  end

  create_table "doctors", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "moderator", default: false
    t.date "birthday"
    t.boolean "banned", default: false
    t.string "avatar"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "city_id"
    t.string "phone"
    t.index ["email"], name: "index_doctors_on_email", unique: true
    t.index ["name"], name: "index_doctors_on_name", unique: true
    t.index ["reset_password_token"], name: "index_doctors_on_reset_password_token", unique: true
  end

  create_table "elements", force: :cascade do |t|
    t.string "name"
    t.string "yin_yang"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "wu_xing_meridian_id"
    t.integer "season_meridian_first_id"
    t.integer "trunk_meridian_id"
    t.integer "season_meridian_second_id"
  end

  create_table "layers", force: :cascade do |t|
    t.string "name"
    t.string "leg_meridian_name"
    t.string "arm_meridian_name"
    t.string "leg_meridian_element"
    t.string "arm_meridian_element"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "leg_meridian_id", default: 0, null: false
    t.integer "arm_meridian_id", default: 0, null: false
    t.string "element_ke"
    t.integer "own_element_id"
    t.index ["name"], name: "index_layers_on_name"
  end

  create_table "meridians", force: :cascade do |t|
    t.string "name"
    t.string "energy_name"
    t.string "element_trunk"
    t.string "element_branch"
    t.string "element_ke"
    t.string "alias_ru"
    t.string "short_name_en"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "strong_nutrition_wu_xin_point_id"
    t.integer "weak_nutrition_wu_xin_point_id"
    t.integer "strong_nutrition_season_point_id"
    t.integer "weak_nutrition_season_point_id"
  end

  create_table "patients", force: :cascade do |t|
    t.string "name"
    t.datetime "birthdate"
    t.integer "doctor_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "diagnosis"
    t.text "description"
    t.integer "city_id"
    t.index ["doctor_id"], name: "index_patients_on_doctor_id"
  end

  create_table "points", force: :cascade do |t|
    t.string "name"
    t.string "alias_en"
    t.string "alias_ru"
    t.string "alias_cn"
    t.string "own_element"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "own_element_id"
    t.integer "meridian_id"
    t.integer "serial_number"
    t.string "function"
    t.string "big_nutrition_point"
    t.string "small_nutrition_point"
    t.index ["name"], name: "index_points_on_name"
  end

  create_table "truncs", force: :cascade do |t|
    t.integer "serial_number"
    t.string "name"
    t.string "element"
    t.integer "year_meridian_id"
    t.string "alias_ru"
    t.string "alias_ch"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "trunks", force: :cascade do |t|
    t.string "name"
    t.string "serial_number"
    t.string "trunk_energy"
    t.integer "year_meridian_id"
    t.integer "day_meridian_id"
    t.string "alias_ru"
    t.string "alias_ch"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "visits", force: :cascade do |t|
    t.datetime "visited_at"
    t.string "treatment"
    t.integer "patient_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "visit_description"
    t.index ["patient_id"], name: "index_visits_on_patient_id"
  end

end
