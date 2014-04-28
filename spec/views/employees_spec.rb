require 'spec_helper'

describe "Employees pages" do
  before { sign_in_user }
  subject { page }

  describe "Index page" do
    before { visit employees_path }

    it { should have_title('| Employees') }

    describe "Content on page" do
      it { should have_content('Сотрудники') }
      it { should have_content('Новый сотрудник') }
    end

    describe "Buttons on page" do
      it { should have_selector('button', :text => 'Создать') }
      it { should have_selector('button', :text => 'Удалить') }
    end

    describe "Columns in main grid" do
      it { should have_selector('thead th', :text => 'Номер') }
      it { should have_selector('thead th', :text => 'Имя') }
    end

    describe "Fields in creation form" do
      it { should have_selector('#newEmployee label', :text => 'Имя') }
    end
  end

end