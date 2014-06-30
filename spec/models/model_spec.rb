require 'spec_helper'

describe Model do
	let(:model) { FactoryGirl.build(:model) }

	subject { model }

	it { should respond_to(:name) }

	it { should be_valid }

	describe "when name is not present" do
		before { model.name = " " }
		it { should_not be_valid }
	end

	describe "when name is already taken" do
		before do
			model_with_same_name = model.dup
			model_with_same_name.save
		end

		it { should_not be_valid }
	end
end