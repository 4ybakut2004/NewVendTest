require 'spec_helper'

describe Request do	
	before { 
		@machine  = Machine.create
		@request = Request.new(description: "Новая заявка", 
									request_type: "phone", 
									phone: "89999999999",
									machine_id: @machine.id) 
	}

  	subject { @request }

  	it { should respond_to(:description) }
  	it { should respond_to(:request_type) }
  	it { should respond_to(:phone) }
  	it { should respond_to(:machine_id) }
  	it { should respond_to(:employee) }

  	it { should be_valid }

  	describe "when request_type is not present" do
		before { @request.request_type = " " }
		it { should_not be_valid }
	end

	describe "when machine_id is not present" do
		before { @request.machine_id = nil }
		it { should_not be_valid }
	end
end