class AddIndexesToRequestMessages < ActiveRecord::Migration
  def change
  	add_index :request_messages, [:message_id, :request_id]
  end
end
