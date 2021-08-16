class CreateTweetRules < ActiveRecord::Migration[6.1]
  def change
    create_table :tweet_rules do |t|
      t.text :value
      t.string :category
      t.timestamps
    end
  end
end
