require 'spec_helper'

describe SalesLocation do
	let(:sales_location) { FactoryGirl.build(:sales_location) }

	subject { sales_location }

	it { should respond_to(:name) }
	it { should respond_to(:address) }
	it { should respond_to(:vendor_id) }

	it { should respond_to(:vendor) }
	it { should respond_to(:machines) }

	it { should be_valid }

	describe "when name is not present" do
		before { sales_location.name = " " }
		it { should_not be_valid }
	end

	describe "when name is already taken" do
		before do
			sales_location_with_same_name = sales_location.dup
			sales_location_with_same_name.save
		end

		it { should_not be_valid }
	end
end