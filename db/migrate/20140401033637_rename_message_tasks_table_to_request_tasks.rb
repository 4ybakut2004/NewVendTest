class RenameMessageTasksTableToRequestTasks < ActiveRecord::Migration
  def change
  	rename_table :message_tasks, :request_tasks
  end
end
