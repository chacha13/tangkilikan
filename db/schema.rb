# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 7) do

  create_table "faqs", :force => true do |t|
    t.integer "user_id",    :null => false
    t.text    "bio"
    t.text    "skills"
    t.text    "schools"
    t.text    "companies"
    t.text    "music"
    t.text    "movies"
    t.text    "television"
    t.text    "magazines"
    t.text    "books"
  end

  create_table "photos", :force => true do |t|
    t.string   "caption",    :limit => 1000
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "profile_id"
    t.string   "image"
  end

  add_index "photos", ["profile_id"], :name => "index_photos_on_profile_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :default => "", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "specs", :force => true do |t|
    t.integer "user_id",                    :null => false
    t.string  "first_name", :default => ""
    t.string  "last_name",  :default => ""
    t.string  "gender"
    t.integer "age",        :default => 0
    t.date    "birthdate"
    t.string  "occupation", :default => ""
    t.string  "streetno",   :default => ""
    t.string  "city",       :default => ""
    t.string  "province",   :default => ""
  end

  create_table "users", :force => true do |t|
    t.string   "user_name"
    t.string   "email"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "authorization_token"
  end

end
