class AddIndexesInRequestTypeMessages < ActiveRecord::Migration
  def change
  	add_index :request_type_messages, [:message_id, :request_type_id], :unique => true
  end
end
