class AddIndexesInMessagesTable < ActiveRecord::Migration
  def change
  	add_index :messages, :name, :unique => true
  end
end
