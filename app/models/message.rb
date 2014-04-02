class Message < ActiveRecord::Base
	has_many :request_messages, dependent: :destroy
  	has_many :requests, through: :request_messages
  	has_many :message_tasks, dependent: :destroy
  	has_many :tasks, through: :message_tasks

  	validates :name, presence: true
  	validates :request_type, presence: true
end