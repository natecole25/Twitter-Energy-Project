class ChangeTextColumnType < ActiveRecord::Migration[6.1]
  def change
    change_column :tweets, :text, :text
  end
end
