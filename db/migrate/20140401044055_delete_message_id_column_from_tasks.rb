class DeleteMessageIdColumnFromTasks < ActiveRecord::Migration
  def change
  	remove_column :tasks, :message_id
  end
end
