require 'spec_helper'

describe Employee do
	let(:employee) { FactoryGirl.build(:employee) }

  	subject { employee }

  	it { should respond_to(:name) }
  	it { should respond_to(:email) }
  	it { should respond_to(:phone) }
  	it { should respond_to(:next_sms_code) }
  	it { should respond_to(:first_code_is_free) }

  	it { should respond_to(:lock_first_code) }
  	it { should respond_to(:free_first_code) }
  	it { should respond_to(:get_next_sms_code) }

  	it { should be_valid }

	describe "when email format is invalid" do
		it "should be invalid" do
			addresses = %w[user@foo,com user_at_foo.org example.user@foo.
			             foo@bar_baz.com foo@bar+baz.com foo@bar..com]
			addresses.each do |invalid_address|
				employee.email = invalid_address
				expect(employee).not_to be_valid
			end
		end
	end

	describe "when email format is valid" do
		it "should be valid" do
			addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn A_US-ER@f.b1.org]
			addresses.each do |valid_address|
				employee.email = valid_address
				expect(employee).to be_valid
			end
		end
	end

  	describe "when name is not present" do
		before { employee.name = " " }
		it { should_not be_valid }
	end
end
