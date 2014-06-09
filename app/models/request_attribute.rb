class RequestAttribute < ActiveRecord::Base
	belongs_to :request_message
	belongs_to :attribute

	validates :request_message_id, presence: true
	validates :attribute_id, presence: true
end
