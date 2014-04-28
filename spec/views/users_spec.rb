require 'spec_helper'

describe "Users pages" do
  before { sign_in_user }
  subject { page }

  describe "Index page" do
    before { visit users_path }

    it { should have_title('| Users') }

    describe "Content on page" do
      it { should have_content('Пользователи') }
    end

    describe "Columns in main grid" do
      it { should have_selector('thead th', :text => 'Номер') }
      it { should have_selector('thead th', :text => 'Логин') }
      it { should have_selector('thead th', :text => 'Полное имя') }
    end
  end

end