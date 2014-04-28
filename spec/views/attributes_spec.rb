require 'spec_helper'

describe "Attributes pages" do
  before { sign_in_user }
  subject { page }

  describe "Index page" do
    before { visit attributes_path }

    it { should have_title('| Attributes') }

    describe "Content on page" do
      it { should have_content('Типы атрибутов') }
      it { should have_content('Новый тип атрибута') }
    end

    describe "Buttons on page" do
      it { should have_selector('button', :text => 'Создать') }
      it { should have_selector('button', :text => 'Удалить') }
    end

    describe "Columns in main grid" do
      it { should have_selector('thead th', :text => 'Номер') }
      it { should have_selector('thead th', :text => 'Наименование') }
      it { should have_selector('thead th', :text => 'Тип') }
    end

    describe "Fields in creation form" do
      it { should have_selector('#newAttribute label', :text => 'Наименование') }
      it { should have_selector('#newAttribute label', :text => 'Тип атрибута') }
    end
  end

end