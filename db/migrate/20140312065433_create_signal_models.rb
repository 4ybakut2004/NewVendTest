class CreateSignalModels < ActiveRecord::Migration
  def change
    create_table :signal_models do |t|
      t.string :name

      t.timestamps
    end
  end
end
