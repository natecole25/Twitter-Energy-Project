# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_08_16_153319) do

  create_table "tweet_rules", force: :cascade do |t|
    t.text "value"
    t.string "category"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tweets", force: :cascade do |t|
    t.integer "tweet_id"
    t.text "tweet_text"
    t.integer "retweet_count"
    t.integer "reply_count"
    t.integer "author_id"
    t.datetime "date_tweeted"
    t.string "tag"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "tweet_rule_id"
    t.index ["tweet_rule_id"], name: "index_tweets_on_tweet_rule_id"
  end

  add_foreign_key "tweets", "tweet_rules"
end
