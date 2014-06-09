class AddIndexesToMessageAttributesTable < ActiveRecord::Migration
  def change
  	add_index :message_attributes, [:message_id, :attribute_id], :unique => true
  end
end
