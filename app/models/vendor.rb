class Vendor < ActiveRecord::Base
	validates :name, presence: true, uniqueness: true

	has_many :sales_locations
end
