class Request < ActiveRecord::Base
	belongs_to :machine
	has_many :request_signals, dependent: :destroy
  	has_many :signal_models, through: :request_signals

	validates :machine_id, presence: true
	validate :validate_machine_id
	validates_inclusion_of :request_type, :in => [:phone, :other]

	REQUEST_TYPES = {
	    :phone => "С Телефона",
	    :other => "Произвольная"
	}

	def request_type
    	read_attribute(:request_type).to_sym
    end

    def request_type= (value)
    	write_attribute(:request_type, value.to_s)
    end

    def self.request_types
    	REQUEST_TYPES
    end

	private

	  def validate_machine_id
	    errors.add(:machine_id, "is invalid") unless Machine.exists?(self.machine_id)
	  end
end
