class Task < ActiveRecord::Base
	has_many :message_tasks, dependent: :destroy
  	has_many :messages, through: :message_tasks
	has_many :request_tasks, dependent: :destroy

	validates :name, presence: true
end
