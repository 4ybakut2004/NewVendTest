class NewVendSettings < ActiveRecord::Base
	def self.getSettings
		NewVendSettings.first
	end
end
