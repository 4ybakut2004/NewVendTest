class Machine < ActiveRecord::Base
	has_many :requests, dependent: :destroy

	require 'open-uri'

	def self.loadMachines
		machines_json = JSON.parse(open("http://lifehack.ru/machines.json").read.force_encoding("Windows-1251").encode("UTF-8"))
		machines_info = machines_json["Machines"]
		machines_info.each { |machine|
			current = Machine.where(:uid => machine["UID"]).take
			if current
				current.update(:name => machine["Name"],
					           :location => machine["Location"],
					           :machine_type => machine["MachineType"])
			else
				Machine.create(:uid => machine["UID"], 
					           :name => machine["Name"],
					           :location => machine["Location"],
					           :machine_type => machine["MachineType"])
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
