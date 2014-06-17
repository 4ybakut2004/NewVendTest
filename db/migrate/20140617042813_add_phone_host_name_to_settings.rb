class AddPhoneHostNameToSettings < ActiveRecord::Migration
  def change
  	add_column :new_vend_settings, :phone_host_name, :string
  end
end
