class RequestMessage < ActiveRecord::Base
	belongs_to :message
	belongs_to :request

	has_many :request_tasks, dependent: :destroy
	has_many :tasks, through: :request_tasks
	has_many :request_attributes, dependent: :destroy

	validates :message_id, presence: true
	validates :request_id, presence: true
end
