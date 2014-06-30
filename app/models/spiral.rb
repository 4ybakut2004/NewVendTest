class Spiral < ActiveRecord::Base
	validates :name, presence: true, uniqueness: true

	validates_inclusion_of :direction, :in => [:left, :right]

	DIRECTIONS = {
		:left => "Левое",
		:right => "Правое"
	}

	def direction
		read_attribute(:direction).to_sym
	end

	def direction= (value)
		write_attribute(:direction, value.to_s)
	end

	def self.directions
		DIRECTIONS
	end
end
