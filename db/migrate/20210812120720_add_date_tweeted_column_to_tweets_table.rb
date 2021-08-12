class AddDateTweetedColumnToTweetsTable < ActiveRecord::Migration[6.1]
  def change
    add_column :tweets, :date_tweeted, :datetime
    rename_column :tweets, :text, :tweet_text
  end
end
