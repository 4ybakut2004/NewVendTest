class RenameTypeColumnToRequests < ActiveRecord::Migration
  def change
  	remove_column :requests, :type
  	add_column    :requests, :request_type, :string
  end
end
