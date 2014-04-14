class MessageAttribute < ActiveRecord::Base
	belongs_to :attribute
	belongs_to :message
end
