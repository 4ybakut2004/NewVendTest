class AddIndexesIdEmployees < ActiveRecord::Migration
  def change
  	add_index :employees, :name, :unique => true
  end
end
