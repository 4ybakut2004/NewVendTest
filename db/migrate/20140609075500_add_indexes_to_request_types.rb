class AddIndexesToRequestTypes < ActiveRecord::Migration
  def change
  	add_index :request_types, :name, :unique => true
  end
end
