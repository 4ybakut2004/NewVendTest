require 'spec_helper'

describe "Request Types pages" do
  before { sign_in_user }
  subject { page }

  describe "Index page" do
    before { visit request_types_path }

    it { should have_title('Request Types') }

    describe "Content on page" do
      it { should have_content('Типы заявок') }
      it { should have_content('Новый тип заявки') }
    end

    describe "Buttons on page" do
      it { should have_selector('button', :text => 'Создать') }
      it { should have_selector('button', :text => 'Удалить') }
    end

    describe "Columns in main grid" do
      it { should have_selector('thead th', :text => 'Номер') }
      it { should have_selector('thead th', :text => 'Наименование') }
    end

    describe "Fields in creation form" do
      it { should have_selector('#newRequestType label', :text => 'Наименование') }
    end
  end


end