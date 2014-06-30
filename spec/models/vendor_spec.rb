require 'spec_helper'

describe Vendor do
	let(:vendor) { FactoryGirl.build(:vendor) }

	subject { vendor }

	it { should respond_to(:name) }

	it { should respond_to(:sales_locations) }

	it { should be_valid }

	describe "when name is not present" do
		before { vendor.name = " " }
		it { should_not be_valid }
	end

	describe "when name is already taken" do
		before do
			vendor_with_same_name = vendor.dup
			vendor_with_same_name.save
		end

		it { should_not be_valid }
	end
end