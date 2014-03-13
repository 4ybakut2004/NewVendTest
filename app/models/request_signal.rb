class RequestSignal < ActiveRecord::Base
	belongs_to :signal_model
  	belongs_to :request
end
