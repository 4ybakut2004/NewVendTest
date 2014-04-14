class AddDeadlineColumnInTasks < ActiveRecord::Migration
  def change
  	add_column :tasks, :deadline, :integer, default: 5
  end
end
