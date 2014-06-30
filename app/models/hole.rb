class Hole < ActiveRecord::Base
	validates :code, presence: true
end
