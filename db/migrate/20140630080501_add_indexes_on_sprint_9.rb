class AddIndexesOnSprint9 < ActiveRecord::Migration
  def change
    add_index :spirals, :name, :unique => true
    add_index :motors, :name, :unique => true
    add_index :models, :name, :unique => true
    add_index :holes, :code
    add_index :vendors, :name, :unique => true
    add_index :sales_locations, :name, :unique => true
  end
end
