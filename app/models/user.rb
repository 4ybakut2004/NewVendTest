class User < ActiveRecord::Base
	validates :name,     presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 50 }
	validates :password_digest, presence: true

	belongs_to :employee

	before_create :create_remember_token

	has_secure_password

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
