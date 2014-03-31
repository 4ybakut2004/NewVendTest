require 'spec_helper'

describe Employee do
  	before { 
		@employee = Employee.create(:name => "Сотрудник")
	}

  	subject { @employee }

  	it { should respond_to(:name) }

  	it { should be_valid }

  	describe "when name is not present" do
		before { @employee.name = " " }
		it { should_not be_valid }
	end
end
