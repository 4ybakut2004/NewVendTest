class RequestType < ActiveRecord::Base
	validates :name, presence: true

	has_many :request_type_messages, dependent: :destroy
	has_many :messages, through: :request_type_messages

	def attrs
		self.attributes
	end

	def getFullInfo
		attributes = self.attributes
		attributes["messages"] = self.messages

		return attributes
	end
end
