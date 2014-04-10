class CreateMessageAttributes < ActiveRecord::Migration
  def change
    create_table :message_attributes do |t|
      t.integer :message_id
      t.integer :attribute_id

      t.timestamps
    end
  end
end
