class AddRequestTaskIdColumnToRequests < ActiveRecord::Migration
  def change
  	add_column :requests, :request_task_id, :integer
  end
end
