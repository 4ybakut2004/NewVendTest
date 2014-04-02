class MessageTask < ActiveRecord::Base
	belongs_to :task
	belongs_to :message
end
