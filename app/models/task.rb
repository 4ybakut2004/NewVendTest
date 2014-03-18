class Task < ActiveRecord::Base
	belongs_to :message
	has_many :message_tasks, dependent: :destroy
end
