class AddNewColumnsToMachinesAndRemoveOld < ActiveRecord::Migration
  def change
    add_column :machines, :sales_location_id, :integer
    add_column :machines, :model_id, :integer
    add_column :machines, :machine_key, :string
  end
end
