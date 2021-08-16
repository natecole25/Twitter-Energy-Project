class AddRuleIdColumnToTweetRules < ActiveRecord::Migration[6.1]
  def change
    add_column :tweet_rules, :rule_id, :bigint
  end
end
