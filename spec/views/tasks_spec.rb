require 'spec_helper'

describe "Tasks pages" do
  before { sign_in_user }
  subject { page }

  describe "Index page" do
    before { visit tasks_path }

    it { should have_title('| Tasks') }

    describe "Content on page" do
      it { should have_content('Типы поручений') }
      it { should have_content('Новый тип поручения') }
    end

    describe "Buttons on page" do
      it { should have_selector('button', :text => 'Создать') }
      it { should have_selector('button', :text => 'Удалить') }
    end

    describe "Columns in main grid" do
      it { should have_selector('thead th', :text => 'Номер') }
      it { should have_selector('thead th', :text => 'Наименование') }
      it { should have_selector('thead th', :text => 'Плановый срок (дней)') }
      it { should have_selector('thead th', :text => 'Решатель') }
    end

    describe "Fields in creation form" do
      it { should have_selector('#newTask label', :text => 'Наименование') }
      it { should have_selector('#newTask label', :text => 'Плановый срок (дней)') }
      it { should have_selector('#newTask label', :text => 'Решатель') }
    end
  end

end