class User < ActiveRecord::Base
	validates :name,     presence: true, uniqueness: { case_sensitive: false }
	validates :password, presence: true

	belongs_to :employee

	before_create :create_remember_token

	def authenticate(not_encrypted_password)
		self.password == not_encrypted_password && self
	end

	def User.new_remember_token
		SecureRandom.urlsafe_base64
	end

	def User.encrypt(token)
		Digest::SHA1.hexdigest(token.to_s)
	end

	private

		def create_remember_token
			self.remember_token = User.encrypt(User.new_remember_token)
		end
end
