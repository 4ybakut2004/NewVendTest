class AddIndexesInAttributes < ActiveRecord::Migration
  def change
  	add_index :attributes, :name, :unique => true
  end
end
