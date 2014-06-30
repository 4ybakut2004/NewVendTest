class CreateSalesLocations < ActiveRecord::Migration
  def change
    create_table :sales_locations do |t|
      t.string :name
      t.integer :vendor_id
      t.text :address

      t.timestamps
    end
  end
end
