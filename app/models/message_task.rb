class MessageTask < ActiveRecord::Base
	belongs_to :task
	belongs_to :message

	validates :message_id, presence: true
	validates :task_id, presence: true
end
