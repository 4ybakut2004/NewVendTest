require 'spec_helper'

describe User do
  let(:user) { FactoryGirl.build(:user) }

  subject { user }

  it { should respond_to(:name) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:employee_id) }

  it { should be_valid }

  describe "when name is not present" do
  	before { user.name = " " }
  	it { should_not be_valid }
  end

  describe "when password is not present" do
    before { user.password = user.password_confirmation = " " }
    it { should_not be_valid }
  end

  describe "when password doesn't match confirmation" do
    before { user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

  describe "when password_digest is not present" do
  	before { user.password_digest = " " }
  	it { should_not be_valid }
  end

  describe "when name address is already taken" do
    before do
      user_with_same_name = user.dup
      user_with_same_name.save
    end

    it { should_not be_valid }
  end

  describe "return value of authenticate method" do
    before { user.save }
    let(:found_user) { User.find_by(name: user.name) }

    describe "with valid password" do
      it { should eq found_user.authenticate(user.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to be_false }
    end
  end

  it { should respond_to(:remember_token) }
  it { should respond_to(:authenticate) }
end
