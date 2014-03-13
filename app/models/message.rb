class Message < ActiveRecord::Base
	has_many :request_messages, dependent: :destroy
  	has_many :requests, through: :request_messages
end
