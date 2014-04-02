class CreateMessageTasks < ActiveRecord::Migration
  def change
    create_table :message_tasks do |t|
      t.integer :message_id
      t.integer :task_id

      t.timestamps
    end
  end
end
