class MessageAttribute < ActiveRecord::Base
	belongs_to :attribute
	belongs_to :message

	validates :message_id, presence: true
	validates :attribute_id, presence: true
end
