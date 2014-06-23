class ChangeDescriptionsToText < ActiveRecord::Migration
  def change
    change_column :request_tasks, :description, :text
    change_column :request_tasks, :registrar_description, :text
    change_column :request_tasks, :assigner_description, :text
    change_column :request_tasks, :executor_description, :text
    change_column :request_tasks, :auditor_description, :text

    change_column :requests, :description, :text
  end
end
