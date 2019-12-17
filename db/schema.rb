# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_12_17_013705) do

  create_table "headhunters", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_headhunters_on_email", unique: true
    t.index ["reset_password_token"], name: "index_headhunters_on_reset_password_token", unique: true
  end

  create_table "job_vacancies", force: :cascade do |t|
    t.string "title"
    t.text "vacancy_description"
    t.text "ability_description"
    t.float "maximum_wage"
    t.integer "level", default: 0
    t.date "limit_date"
    t.string "region"
    t.integer "status", default: 0
    t.integer "headhunter_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "minimum_wage"
    t.index ["headhunter_id"], name: "index_job_vacancies_on_headhunter_id"
  end

end
