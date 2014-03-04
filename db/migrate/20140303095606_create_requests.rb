class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.string :employee
      t.string :machine
      t.string :description

      t.timestamps
    end
  end
end
