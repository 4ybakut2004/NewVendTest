class ChangeTypeColumnToDefaultValue < ActiveRecord::Migration
  def change
  	change_column :requests, :request_type, :string, :default => "phone"
  end
end
