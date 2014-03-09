class CreateMachines < ActiveRecord::Migration
  def change
    create_table :machines do |t|
      t.string :uid
      t.string :name
      t.string :location
      t.string :machine_type

      t.timestamps
    end
    add_index :machines, [:uid]
    add_index :machines, [:name]
  end
end
