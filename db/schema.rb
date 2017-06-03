# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20170529055540) do

  create_table "bills", force: :cascade do |t|
    t.string   "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "diary_logs", force: :cascade do |t|
    t.integer  "user_id"
    t.text     "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "item_types", force: :cascade do |t|
    t.string   "name"
    t.integer  "level"
    t.integer  "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "items", force: :cascade do |t|
    t.integer  "bill_id"
    t.integer  "item_type"
    t.string   "memo"
    t.decimal  "amount",           precision: 6, scale: 1, default: 0.0
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
    t.integer  "parent_type_id"
    t.string   "parent_type_name"
    t.integer  "child_type_id"
    t.string   "child_type_name"
    t.datetime "record_at"
    t.integer  "inorout"
  end

  create_table "users", force: :cascade do |t|
    t.string   "open_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
