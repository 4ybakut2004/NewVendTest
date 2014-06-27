class CreateMotors < ActiveRecord::Migration
  def change
    create_table :motors do |t|
      t.string :name
      t.float :left_spiral_position
      t.float :right_spiral_position
      t.float :left_bound_offset
      t.float :right_bound_offset
      t.integer :mount_priority

      t.timestamps
    end
  end
end
