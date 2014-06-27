require 'spec_helper'

describe Spiral do
	let(:spiral) { FactoryGirl.create(:spiral) }

	subject { spiral }

	it { should respond_to(:name) }
	it { should respond_to(:direction) }
	it { should respond_to(:mount_priority) }

	describe "when name is not present" do
		before { spiral.name = " " }
		it { should_not be_valid }
	end

	describe "when direction is not in left or right" do
		before { spiral.direction = "bottom" }
		it { should_not be_valid }
	end

	it { should be_valid }
end