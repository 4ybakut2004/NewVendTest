class AddIsReadColumnsToRequestTasks < ActiveRecord::Migration
  def change
  	add_column :request_tasks, :is_read_by_assigner, :boolean, default: false
  	add_column :request_tasks, :is_read_by_executor, :boolean, default: false
  	add_column :request_tasks, :is_read_by_auditor, :boolean, default: false
  end
end
