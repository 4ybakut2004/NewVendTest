require 'spec_helper'

describe Motor do
	let(:motor) { FactoryGirl.build(:motor) }

	subject { motor }

	it { should respond_to(:name) }
	it { should respond_to(:left_spiral_position) }
	it { should respond_to(:right_spiral_position) }
	it { should respond_to(:left_bound_offset) }
	it { should respond_to(:right_bound_offset) }
	it { should respond_to(:mount_priority) }

	it { should be_valid }

	describe "when name is not present" do
		before { motor.name = " " }
		it { should_not be_valid }
	end

	describe "when name is already taken" do
		before do
			motor_with_same_name = motor.dup
			motor_with_same_name.save
		end

		it { should_not be_valid }
	end
end