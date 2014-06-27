class Motor < ActiveRecord::Base
	validates :name, presence: true
end
