class AddSendTimeColumnsToRequestTasks < ActiveRecord::Migration
  def change
  	add_column :request_tasks, :email_to_assigner_date, :datetime
  	add_column :request_tasks, :email_to_executor_date, :datetime
  	add_column :request_tasks, :email_to_auditor_date, :datetime
  end
end
