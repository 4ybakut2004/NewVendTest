class AddIndexesToRequestAttributes < ActiveRecord::Migration
  def change
  	add_index :request_attributes, [:attribute_id, :request_message_id], :unique => true
  end
end
