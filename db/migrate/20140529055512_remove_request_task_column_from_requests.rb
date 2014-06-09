class RemoveRequestTaskColumnFromRequests < ActiveRecord::Migration
  def change
  	remove_column :requests, :request_task_id
  end
end
