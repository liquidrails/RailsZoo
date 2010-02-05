# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20081129122203) do

  create_table "administrators", :force => true do |t|
    t.string   "login"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "last_login"
    t.string   "password_salt"
    t.string   "password_hash"
  end

  create_table "butterwords", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  create_table "categories", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.integer  "order"
  end

  add_index "categories", ["name"], :name => "index_categories_on_name"

  create_table "flagnames", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "flags_count", :default => 0
  end

  create_table "weblinks", :force => true do |t|
    t.string   "address"
    t.boolean  "approved", :default => 0  # 1=approved
    t.string   "submitted_by"  #email address of submitter
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "postings_count", :default => 0
  end

  create_table "flags", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "flagname_id"
    t.integer  "posting_id"
    t.string   "client_ip"
  end

  create_table "locations", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "country"
    t.string   "state"
  end

  add_index "locations", ["name"], :name => "index_locations_on_name"

#status:  0 not validated, 1 active, 2 expired, 3 deleted by user, 4 deleted by admin, 5 flagged deletion
  create_table "postings", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "headline"
    t.string   "headline_sort"
    t.text     "details"
    t.string   "organizer"
    t.string   "organizer_sort"
    t.string   "contact"
    t.string   "email"
    t.integer  "postlink"   # 1=yes, 0=no
    t.string   "linkcode"
    t.string   "linkemail"
    t.date     "departure"
    t.integer  "departure_month"
    t.integer  "departure_year"
    t.date     "return"
    t.integer  "duration"
    t.integer  "subcategory_id"
    t.integer  "ipn_id", :default => -99
    t.integer  "weblink_id"
    t.string   "key"
    t.boolean  "validated"
    t.integer  "list_status", :default => 0
    t.datetime "expiration_date"
    t.string   "display_email"
    t.integer  "flags_count",    :default => 0
  end

  add_index "postings", ["subcategory_id"], :name => "index_postings_on_subcategory"
  add_index "postings", ["departure"], :name => "index_postings_on_departure"
  add_index "postings", ["duration"], :name => "index_postings_on_duration"
  add_index "postings", ["organizer"], :name => "index_postings_on_organizer"
  add_index "postings", ["headline"], :name => "index_postings_on_headline"
  add_index "postings", ["status"], :name => "index_postings_on_status"

  create_table "simple_captcha_data", :force => true do |t|
    t.string   "key",        :limit => 40
    t.string   "value",      :limit => 6
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subcategories", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "subname_id"
    t.integer  "location_id",    :default => 0
    t.integer  "category_id"
    t.integer  "postings_count", :default => 0  #add active_postings_count
    t.boolean  "status",         :default => true
  end

  add_index "subcategories", ["status", "location_id", "category_id"], :name => "index_subcategories_on_status_and_location_id_and_category_id"

  create_table "subnames", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  add_index "subnames", ["name"], :name => "index_subnames_on_name"

  create_table "ipns", :force => true do |t|
    t.datetime "created_at"
    t.datetime "purchased_at"
    t.datetime "expires_at"
    t.text     "params"
    t.string   "status"
    t.string   "transaction_id"
    t.integer  "postings_count", :default => 0
    t.string   "email"
    t.string   "code"
    t.datetime "email_sent_at"
    t.string   "first_name"
    t.string   "last_name"

    add_index "ipns", ["code"], :name => "index_ipns_on_code"
  end


end
