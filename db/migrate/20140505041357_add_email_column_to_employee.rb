class AddEmailColumnToEmployee < ActiveRecord::Migration
  def change
  	add_column :employees, :email, :string
  end
end
