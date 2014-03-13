class SignalModel < ActiveRecord::Base
	has_many :request_signals, dependent: :destroy
  	has_many :requests, through: :request_signals
end
