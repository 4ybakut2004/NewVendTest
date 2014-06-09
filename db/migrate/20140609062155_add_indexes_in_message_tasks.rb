class AddIndexesInMessageTasks < ActiveRecord::Migration
  def change
    add_index :message_tasks, [:message_id, :task_id], :unique => true
  end
end
