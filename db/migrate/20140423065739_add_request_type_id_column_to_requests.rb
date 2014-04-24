class AddRequestTypeIdColumnToRequests < ActiveRecord::Migration
  def change
  	add_column :requests, :request_type_id, :integer, default: RequestType.first.id || 0
  end
end
