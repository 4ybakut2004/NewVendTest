require 'spec_helper'

describe Shelf do
	let(:shelf) { FactoryGirl.build(:shelf) }

	subject { shelf }

	it { should respond_to(:name) }

	it { should be_valid }

	describe "when name is not present" do
		before { shelf.name = " " }
		it { should_not be_valid }
	end

	describe "when name is already taken" do
		before do
			shelf_with_same_name = shelf.dup
			shelf_with_same_name.save
		end

		it { should_not be_valid }
	end
end