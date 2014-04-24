class RemoveRequestTypeColumnFromRequestsAndMessages < ActiveRecord::Migration
  def change
  	remove_column :requests, :request_type
  	remove_column :messages, :request_type
  end
end
