class RequestMessage < ActiveRecord::Base
	belongs_to :message
  	belongs_to :request

  	has_many :message_tasks, dependent: :destroy
  	has_many :tasks, through: :message_tasks
end
