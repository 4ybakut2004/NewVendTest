require 'spec_helper'

describe Request do	
	before { 
		@user = User.create(name: "Example User", password_digest: "Very Strong Password")
		@machine  = Machine.create
		@request = Request.new(description: "Новая заявка", 
									request_type: :phone, 
									phone: "89999999999",
									machine_id: @machine.id,
									registrar_id: @user.id,
									solver_id: @user.id) 
	}

  	subject { @request }

  	it { should respond_to(:description) }
  	it { should respond_to(:request_type) }
  	it { should respond_to(:phone) }
  	it { should respond_to(:machine_id) }
  	it { should respond_to(:registrar_id) }
  	it { should respond_to(:solver_id) }

  	it { should be_valid }

  	describe "when request_type is not present" do
		before { @request.request_type = " " }
		it { should_not be_valid }
	end

	describe "when machine_id is not present" do
		before { @request.machine_id = nil }
		it { should_not be_valid }
	end

	describe "when registrar_id is not present" do
		before { @request.registrar_id = nil }
		it { should_not be_valid }
	end

	describe "when solver_id is not present" do
		before { @request.solver_id = nil }
		it { should_not be_valid }
	end
end