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

ActiveRecord::Schema.define(version: 20140120231838) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "events", force: true do |t|
    t.tstzrange "started_at"
    t.tstzrange "finished_at"
    t.string    "description"
    t.string    "category"
    t.integer   "references_count", default: 0
    t.hstore    "locations",        default: {}
    t.hstore    "actors",           default: {}
  end

  add_index "events", ["finished_at"], name: "index_events_on_finished_at", using: :gist
  add_index "events", ["started_at"], name: "index_events_on_started_at", using: :gist

  create_table "places", force: true do |t|
    t.string "woe_id"
    t.string "name"
    t.string "country"
    t.text   "bounding_box_coordinates", default: [], array: true
  end

  create_table "references", force: true do |t|
    t.integer "tweet_id",  null: false
    t.integer "event_id",  null: false
    t.integer "certainty"
  end

  add_index "references", ["event_id"], name: "index_references_on_event_id", using: :btree
  add_index "references", ["tweet_id", "event_id"], name: "index_references_on_tweet_id_and_event_id", unique: true, using: :btree
  add_index "references", ["tweet_id"], name: "index_references_on_tweet_id", using: :btree

  create_table "tweets", force: true do |t|
    t.string   "twitter_id"
    t.string   "text"
    t.datetime "created_at"
    t.text     "coordinates",    default: [],              array: true
    t.integer  "user_id",                     null: false
    t.integer  "place_id",                    null: false
    t.text     "named_entities", default: [],              array: true
    t.text     "tags",           default: [],              array: true
    t.string   "category"
  end

  create_table "users", force: true do |t|
    t.string   "twitter_id"
    t.string   "name"
    t.string   "screen_name"
    t.string   "description"
    t.string   "website_url"
    t.string   "image_url"
    t.string   "location"
    t.integer  "followers_count"
    t.datetime "created_at"
  end

end
