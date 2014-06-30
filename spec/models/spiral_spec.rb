require 'spec_helper'

describe Spiral do
	let(:spiral) { FactoryGirl.build(:spiral) }

	subject { spiral }

	it { should respond_to(:name) }
	it { should respond_to(:direction) }
	it { should respond_to(:mount_priority) }

	it { should be_valid }

	describe "when name is not present" do
		before { spiral.name = " " }
		it { should_not be_valid }
	end

	describe "when direction is not in left or right" do
		before { spiral.direction = "bottom" }
		it { should_not be_valid }
	end

	describe "when name is already taken" do
		before do
			spiral_with_same_name = spiral.dup
			spiral_with_same_name.save
		end

		it { should_not be_valid }
	end
end