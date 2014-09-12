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

ActiveRecord::Schema.define(version: 20140911195252) do

  create_table "api_settings", force: true do |t|
    t.string "type"
    t.string "homepage"
    t.string "api_endpoint"
    t.string "auth_email"
    t.string "auth_token"
  end

  add_index "api_settings", ["type"], name: "index_api_settings_on_type", unique: true, using: :btree

  create_table "arps", force: true do |t|
    t.string   "file_location"
    t.string   "machine_mode"
    t.string   "sku"
    t.string   "platen"
    t.integer  "resolution"
    t.string   "ink"
    t.integer  "ink_volume"
    t.integer  "highlight3"
    t.integer  "mask3"
    t.integer  "highlightp"
    t.integer  "maskp"
    t.boolean  "print_with_black_ink"
    t.boolean  "cmy_gray"
    t.boolean  "multiple_pass"
    t.boolean  "transparency"
    t.integer  "transparency_red"
    t.integer  "transparency_blue"
    t.integer  "transparency_green"
    t.integer  "tolerance"
    t.integer  "choke_width"
    t.boolean  "white_color_pause"
    t.boolean  "unidirectional"
    t.decimal  "width",                precision: 5, scale: 2
    t.decimal  "height",               precision: 5, scale: 2
    t.decimal  "from_top",             precision: 5, scale: 2
    t.decimal  "from_center",          precision: 5, scale: 2
    t.decimal  "cmyk_ink_colume",      precision: 5, scale: 2
    t.decimal  "white_ink_volume",     precision: 5, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "complete"
  end

  add_index "arps", ["complete"], name: "index_arps_on_complete", using: :btree
  add_index "arps", ["platen"], name: "index_arps_on_platen", using: :btree
  add_index "arps", ["sku"], name: "index_arps_on_sku", using: :btree

  create_table "mass_lines", force: true do |t|
    t.string   "prefix"
    t.string   "file_location_prefix"
    t.string   "machine_mode"
    t.string   "platen"
    t.integer  "resolution"
    t.string   "ink"
    t.integer  "ink_volume"
    t.integer  "highlight3"
    t.integer  "mask3"
    t.integer  "highlightp"
    t.integer  "maskp"
    t.boolean  "print_with_black_ink"
    t.boolean  "cmy_gray"
    t.boolean  "multiple_pass"
    t.boolean  "transparency"
    t.integer  "transparency_red"
    t.integer  "transparency_blue"
    t.integer  "transparency_green"
    t.integer  "tolerance"
    t.integer  "choke_width"
    t.boolean  "white_color_pause"
    t.boolean  "unidirectional"
    t.decimal  "width",                precision: 5, scale: 2
    t.decimal  "height",               precision: 5, scale: 2
    t.decimal  "from_top",             precision: 5, scale: 2
    t.decimal  "from_center",          precision: 5, scale: 2
    t.decimal  "cmyk_ink_colume",      precision: 5, scale: 2
    t.decimal  "white_ink_volume",     precision: 5, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "mass_lines", ["platen"], name: "index_mass_lines_on_platen", using: :btree
  add_index "mass_lines", ["prefix"], name: "index_mass_lines_on_prefix", using: :btree

  create_table "spreadsheets", force: true do |t|
    t.integer  "user_id"
    t.integer  "batch_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.string   "state"
  end

  add_index "spreadsheets", ["state"], name: "index_spreadsheets_on_state", using: :btree

end
