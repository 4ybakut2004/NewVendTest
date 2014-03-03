require 'spec_helper'

describe User do
  before { @user = User.new(name: "Example User", password: "Very Strong Password") }

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:password) }

  it { should be_valid }

  describe "when name is not present" do
	before { @user.name = " " }
	it { should_not be_valid }
  end

  describe "when password is not present" do
	before { @user.password = " " }
	it { should_not be_valid }
  end

  describe "when name address is already taken" do
    before do
      user_with_same_name = @user.dup
      user_with_same_name.save
    end

    it { should_not be_valid }
  end
end
