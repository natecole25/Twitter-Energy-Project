class CreateTweetsTable < ActiveRecord::Migration[6.1]
  def change
    create_table :tweets_tables do |t|
    t.integer "tweet_id"
    t.text "tweet_text"
    t.integer "retweet_count"
    t.integer "reply_count"
    t.integer "author_id"
    t.datetime "date_tweeted"
    t.string "tag"
      t.timestamps
    end
  end
end
