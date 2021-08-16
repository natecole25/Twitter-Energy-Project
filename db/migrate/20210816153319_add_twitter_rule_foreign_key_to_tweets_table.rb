class AddTwitterRuleForeignKeyToTweetsTable < ActiveRecord::Migration[6.1]
  def change
    add_reference :tweets, :tweet_rule, foreign_key: true
  end
end
