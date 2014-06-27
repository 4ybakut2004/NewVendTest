class CreateSpirals < ActiveRecord::Migration
  def change
    create_table :spirals do |t|
      t.string :name
      t.string :direction
      t.integer :mount_priority

      t.timestamps
    end
  end
end
