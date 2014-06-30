class SalesLocation < ActiveRecord::Base
	validates :name, presence: true, uniqueness: true

	belongs_to :vendor
	has_many :machines
end
