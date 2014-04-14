class RequestAttribute < ActiveRecord::Base
	belongs_to :request_message
	belongs_to :attribute
end
