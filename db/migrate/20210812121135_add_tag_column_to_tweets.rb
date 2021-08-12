class AddTagColumnToTweets < ActiveRecord::Migration[6.1]
  def change
    add_column :tweets, :tag, :string 
  end
end
