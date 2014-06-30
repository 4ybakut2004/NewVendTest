class AddFirstCodeIsFreeColumnToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :first_code_is_free, :boolean, default: true
  end
end
