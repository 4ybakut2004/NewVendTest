class CreateMessageTasks < ActiveRecord::Migration
  def change
    create_table :message_tasks do |t|
      t.integer :assigner_id
      t.integer :executor_id
      t.integer :auditor_id
      t.string :description
      t.integer :request_message_id
      t.integer :task_id

      t.timestamps
    end
  end
end
