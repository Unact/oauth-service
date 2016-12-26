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

ActiveRecord::Schema.define(version: 20161201120127) do

  create_table "oauth_service_oauth_access_tokens", force: :cascade do |t|
    t.integer  "oauth_user_id"
    t.integer  "oauth_client_id"
    t.string   "access_token"
    t.datetime "expires"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "oauth_service_oauth_access_tokens", ["access_token"], name: "index_oauth_service_oauth_access_tokens_on_access_token", unique: true

  create_table "oauth_service_oauth_authorization_codes", force: :cascade do |t|
    t.integer  "oauth_user_id"
    t.integer  "oauth_client_id"
    t.string   "code"
    t.datetime "code_expires"
    t.string   "refresh_token"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "oauth_service_oauth_authorization_codes", ["code"], name: "index_oauth_service_oauth_authorization_codes_on_code", unique: true
  add_index "oauth_service_oauth_authorization_codes", ["refresh_token"], name: "index_oauth_service_oauth_authorization_codes_on_refresh_token", unique: true

  create_table "oauth_service_oauth_clients", force: :cascade do |t|
    t.string   "name"
    t.string   "client_id"
    t.string   "client_secret"
    t.string   "redirect_uri"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "oauth_service_oauth_clients", ["client_id"], name: "index_oauth_service_oauth_clients_on_client_id", unique: true
  add_index "oauth_service_oauth_clients", ["client_secret"], name: "index_oauth_service_oauth_clients_on_client_secret", unique: true

  create_table "oauth_service_oauth_users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
