class AddDateColumnsToMessageTasks < ActiveRecord::Migration
  def change
  	add_column :message_tasks, :creation_date, :datetime
  	add_column :message_tasks, :execution_date, :datetime
  	add_column :message_tasks, :audition_date, :datetime
  end
end
