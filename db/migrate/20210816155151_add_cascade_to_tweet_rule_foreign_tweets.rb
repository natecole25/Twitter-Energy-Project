class AddCascadeToTweetRuleForeignTweets < ActiveRecord::Migration[6.1]
  def change
    remove_reference :tweets, :tweet_rule
    add_reference :tweets, :tweet_rule, foreign_key: true, on_delete: :cascade
  end
end
