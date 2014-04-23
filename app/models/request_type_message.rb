class RequestTypeMessage < ActiveRecord::Base
	validates :request_type_id, presence: true
	validates :message_id, presence: true

	belongs_to :message
	belongs_to :request_type
end
