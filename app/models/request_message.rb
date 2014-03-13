class RequestMessage < ActiveRecord::Base
	belongs_to :message
  	belongs_to :request
end
