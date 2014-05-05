class AddMenuPositionColumnToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :menu_position, :string, default: "shown"
  end
end
