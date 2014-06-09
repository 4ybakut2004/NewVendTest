class User < ActiveRecord::Base
	include ActiveModel::Dirty

	validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 50 }
	validates :password_digest, presence: true

	belongs_to :employee

	before_create :create_remember_token

	has_secure_password

	validates_inclusion_of :menu_position, :in => [:hidden, :shown]

	MENU_POSITIONS = {
		:hidden => "Скрыта",
		:shown => "Показана"
	}

	def menu_position
    	read_attribute(:menu_position).to_sym
    end

    def menu_position= (value)
    	write_attribute(:menu_position, value.to_s)
    end

    def self.menu_positions
    	MENU_POSITIONS
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
