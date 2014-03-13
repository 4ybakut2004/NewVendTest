class CreateRequestSignals < ActiveRecord::Migration
  def change
    create_table :request_signals do |t|
      t.integer :request_id
      t.integer :signal_model_id

      t.timestamps
    end
  end
end
