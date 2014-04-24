class AddDescriptionColumnsToRequestTasks < ActiveRecord::Migration
  def change
  	add_column :request_tasks, :registrar_description, :string
  	add_column :request_tasks, :assigner_description, :string
  	add_column :request_tasks, :executor_description, :string
  	add_column :request_tasks, :auditor_description, :string
  end
end
