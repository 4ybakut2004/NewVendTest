class ChangeSignalModelsNameToMessages < ActiveRecord::Migration
  def change
  	rename_table :signal_models, :messages
  	rename_table :request_signals, :request_messages

  	remove_column :request_messages, :signal_model_id
  	add_column    :request_messages, :message_id, :integer
  end
end
