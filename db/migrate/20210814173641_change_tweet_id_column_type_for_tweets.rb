class ChangeTweetIdColumnTypeForTweets < ActiveRecord::Migration[6.1]
  def change
    change_column :tweets, :tweet_id, :bigint
  end
end
