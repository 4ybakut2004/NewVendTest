class CreateHoles < ActiveRecord::Migration
  def change
    create_table :holes do |t|
      t.string :code

      t.timestamps
    end
  end
end
