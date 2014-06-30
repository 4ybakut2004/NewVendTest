class Machine < ActiveRecord::Base
	belongs_to :sales_location
	belongs_to :model

	has_many :requests, dependent: :destroy

	require 'open-uri'

	def self.loadMachines
		machines_json = JSON.parse(open("http://lifehack.ru/machines.json").read.force_encoding("Windows-1251").encode("UTF-8"))
		machines_info = machines_json["Machines"]
		machines_info.each { |machine|
			current = Machine.where(:guid => machine["UID"]).first
			if current
				current.update(:name => machine["Name"],
					           :location => machine["Location"])
			else
				Machine.create(:guid => machine["UID"], 
					           :name => machine["Name"],
					           :location => machine["Location"])
			end
		}

		#machines = Machine.all
		#machines.each { |machine|
		#	if !(machines_info.detect { |m| m["UID"] == machine.uid })
		#		machine.destroy
		#	end
		#}
	end
end
