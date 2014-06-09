class AddIndexesInTasks < ActiveRecord::Migration
  def change
  	add_index :tasks, :name, :unique => true
  end
end
