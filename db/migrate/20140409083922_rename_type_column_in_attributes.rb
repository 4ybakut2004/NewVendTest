class RenameTypeColumnInAttributes < ActiveRecord::Migration
  def change
  	rename_column :attributes, :type, :attribute_type
  end
end
