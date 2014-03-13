class AddRequestTypeInSignalModels < ActiveRecord::Migration
  def change
  	add_column    :signal_models, :request_type, :string
  end
end
