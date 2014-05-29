class AddHostNameColumnToNewVendSettingsTable < ActiveRecord::Migration
  def change
  	add_column :new_vend_settings, :host_name, :string
  end
end
