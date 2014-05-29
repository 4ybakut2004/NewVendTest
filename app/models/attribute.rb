class Attribute < ActiveRecord::Base
	include ActiveModel::Dirty

	has_many :message_attributes, dependent: :destroy
	has_many :messages, through: :message_attributes

	validates :name, presence: true, uniqueness: true
	validates :attribute_type, presence: true

	validates_inclusion_of :attribute_type, :in => [:number, :string]

	ATTRIBUTE_TYPES = {
		:number => "Число",
		:string => "Строка"
	}

	def attribute_type
    	read_attribute(:attribute_type).to_sym
    end

    def attribute_type= (value)
    	write_attribute(:attribute_type, value.to_s)
    end

    def self.attribute_types
    	ATTRIBUTE_TYPES
    end

    def attrs
    	attributes = self.attributes
    	attributes[:attribute_type_name] = ATTRIBUTE_TYPES[self.attribute_type]
		return attributes.merge({ :messages => self.messages.collect { |m| m.name } })
	end
end
