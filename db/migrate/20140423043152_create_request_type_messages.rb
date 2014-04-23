class CreateRequestTypeMessages < ActiveRecord::Migration
  def change
    create_table :request_type_messages do |t|
      t.integer :request_type_id
      t.integer :message_id

      t.timestamps
    end
  end
end
