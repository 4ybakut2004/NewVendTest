class AddRequestTypeIdColumnToRequests < ActiveRecord::Migration
  def change
  	add_column :requests, :request_type_id, :integer
  end
end
