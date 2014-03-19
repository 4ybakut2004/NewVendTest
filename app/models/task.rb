class Task < ActiveRecord::Base
	belongs_to :message
	has_many :message_tasks, dependent: :destroy

	validates :name, presence: true
  	validates :message_id, presence: true
end
