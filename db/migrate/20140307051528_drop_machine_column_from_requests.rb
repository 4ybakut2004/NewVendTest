class DropMachineColumnFromRequests < ActiveRecord::Migration
  def change
  	remove_column :requests, :machine
  	add_column    :requests, :machine_id, :integer
  end
end
