class RemoveEmployeeIdColumnFromMessages < ActiveRecord::Migration
  def change
  	remove_column :messages, :employee_id
  end
end
