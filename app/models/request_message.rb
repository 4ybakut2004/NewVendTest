class RequestMessage < ActiveRecord::Base
	belongs_to :message
  	belongs_to :request

  	has_many :request_tasks, dependent: :destroy
  	has_many :tasks, through: :request_tasks
end
