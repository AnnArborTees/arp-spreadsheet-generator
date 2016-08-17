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

ActiveRecord::Schema.define(version: 20160815200555) do

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
    t.integer  "ink_volume",                                    default: 0
    t.integer  "highlight3",                                    default: 0
    t.integer  "mask3",                                         default: 0
    t.integer  "highlightp",                                    default: 0
    t.integer  "maskp",                                         default: 0
    t.boolean  "print_with_black_ink"
    t.boolean  "cmy_gray"
    t.boolean  "multiple_pass"
    t.boolean  "transparency"
    t.integer  "transparency_red",                              default: 0
    t.integer  "transparency_blue",                             default: 0
    t.integer  "transparency_green",                            default: 0
    t.integer  "tolerance",                                     default: 0
    t.integer  "choke_width",                                   default: 0
    t.boolean  "white_color_pause"
    t.boolean  "unidirectional"
    t.decimal  "width",                 precision: 5, scale: 2
    t.decimal  "height",                precision: 5, scale: 2
    t.decimal  "from_top",              precision: 5, scale: 2
    t.decimal  "from_center",           precision: 5, scale: 2
    t.decimal  "cmyk_ink_volume",       precision: 5, scale: 2
    t.decimal  "white_ink_volume",      precision: 5, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "complete"
    t.integer  "spreadsheet_id"
    t.integer  "pretreat_level"
    t.boolean  "requires_renaming",                             default: false
    t.integer  "customizable_line_id"
    t.boolean  "customizable"
    t.string   "custom_artwork_url"
    t.integer  "customized_artwork_id"
  end

  add_index "arps", ["complete"], name: "index_arps_on_complete", using: :btree
  add_index "arps", ["platen"], name: "index_arps_on_platen", using: :btree
  add_index "arps", ["requires_renaming"], name: "index_arps_on_requires_renaming", using: :btree
  add_index "arps", ["sku"], name: "index_arps_on_sku", using: :btree
  add_index "arps", ["spreadsheet_id"], name: "index_arps_on_spreadsheet_id", using: :btree

  create_table "customizable_lines", force: true do |t|
    t.string   "sku"
    t.string   "spree_variable_name"
    t.string   "mockbot_variable_name"
    t.boolean  "case_sensitive"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customizations", force: true do |t|
    t.integer  "arp_id"
    t.string   "spree_variable"
    t.string   "mockbot_variable"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mass_lines", force: true do |t|
    t.string   "prefix"
    t.string   "file_location_prefix"
    t.string   "machine_mode"
    t.string   "platen"
    t.integer  "resolution"
    t.string   "ink"
    t.integer  "ink_volume",                                   default: 0
    t.integer  "highlight3",                                   default: 0
    t.integer  "mask3",                                        default: 0
    t.integer  "highlightp",                                   default: 0
    t.integer  "maskp",                                        default: 0
    t.boolean  "print_with_black_ink"
    t.boolean  "cmy_gray"
    t.boolean  "multiple_pass"
    t.boolean  "transparency"
    t.integer  "transparency_red",                             default: 0
    t.integer  "transparency_blue",                            default: 0
    t.integer  "transparency_green",                           default: 0
    t.integer  "tolerance",                                    default: 0
    t.integer  "choke_width",                                  default: 0
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
    t.integer  "pretreat_level"
    t.boolean  "requires_renaming",                            default: false
    t.datetime "deleted_at"
  end

  add_index "mass_lines", ["deleted_at"], name: "index_mass_lines_on_deleted_at", using: :btree
  add_index "mass_lines", ["platen"], name: "index_mass_lines_on_platen", using: :btree
  add_index "mass_lines", ["prefix"], name: "index_mass_lines_on_prefix", using: :btree
  add_index "mass_lines", ["requires_renaming"], name: "index_mass_lines_on_requires_renaming", using: :btree

  create_table "spreadsheet_arps", force: true do |t|
    t.integer "spreadsheet_id"
    t.integer "arp_id"
  end

  add_index "spreadsheet_arps", ["arp_id"], name: "index_spreadsheet_arps_on_arp_id", using: :btree
  add_index "spreadsheet_arps", ["spreadsheet_id"], name: "index_spreadsheet_arps_on_spreadsheet_id", using: :btree

  create_table "spreadsheets", force: true do |t|
    t.integer  "user_id"
    t.string   "batch_id"
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
