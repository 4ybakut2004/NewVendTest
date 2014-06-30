class AddSmsCodesColumnsToRequestTasks < ActiveRecord::Migration
  def change
    add_column :request_tasks, :assigner_sms_code, :integer
    add_column :request_tasks, :executor_sms_code, :integer
    add_column :request_tasks, :auditor_sms_code, :integer
  end
end
