class Request < ActiveRecord::Base
	validates :machine,     presence: true
	validates :description, presence: true
end
