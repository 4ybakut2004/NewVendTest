require 'spec_helper'

describe Motor do
	let(:motor) { FactoryGirl.create(:motor) }

	subject { motor }

	it { should respond_to(:name) }
	it { should respond_to(:left_spiral_position) }
	it { should respond_to(:right_spiral_position) }
	it { should respond_to(:left_bound_offset) }
	it { should respond_to(:right_bound_offset) }
	it { should respond_to(:mount_priority) }

	describe "when name is not present" do
		before { motor.name = " " }
		it { should_not be_valid }
	end

	it { should be_valid }
end