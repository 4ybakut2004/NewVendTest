class CreateNewVendSettings < ActiveRecord::Migration
  def change
    create_table :new_vend_settings do |t|
      t.integer :read_confirm_time

      t.timestamps
    end
  end
end
