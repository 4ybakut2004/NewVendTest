class Motor < ActiveRecord::Base
	validates :name, presence: true, uniqueness: true
end
