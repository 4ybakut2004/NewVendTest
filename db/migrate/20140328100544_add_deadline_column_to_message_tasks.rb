class AddDeadlineColumnToMessageTasks < ActiveRecord::Migration
  def change
  	add_column :message_tasks, :deadline_date, :datetime
  end
end
