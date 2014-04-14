class CreateRequestAttributes < ActiveRecord::Migration
  def change
    create_table :request_attributes do |t|
      t.integer :request_message_id
      t.integer :attribute_id
      t.string :value

      t.timestamps
    end
  end
end
