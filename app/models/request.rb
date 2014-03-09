class Request < ActiveRecord::Base
	belongs_to :machine
	validates :machine_id, presence: true
	validates :description, presence: true

	validate :validate_machine_id

	private

	  def validate_machine_id
	    errors.add(:machine_id, "is invalid") unless Machine.exists?(self.machine_id)
	  end
end
