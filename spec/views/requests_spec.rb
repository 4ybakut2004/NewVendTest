require 'spec_helper'

describe "Requests pages" do
  before { sign_in_user }
  subject { page }

  describe "Index page" do
    before { visit requests_path }

    it { should have_title('| Requests') }

    describe "Content on page" do
      it { should have_content('Заявки') }
      it { should have_content('Новая заявка') }
    end

    describe "Buttons on page" do
      it { should have_selector('button', :text => 'Создать') }
      it { should have_selector('button', :text => 'Удалить') }
      it { should have_selector('button', :text => 'Регистратор') }
    end

    describe "Columns in main grid" do
      it { should have_selector('thead th', :text => 'Номер') }
      it { should have_selector('thead th', :text => 'Регистратор') }
      it { should have_selector('thead th', :text => 'Автомат') }
      it { should have_selector('thead th', :text => 'Описание') }
      it { should have_selector('thead th', :text => 'Тип') }
      it { should have_selector('thead th', :text => 'Дата регистрации') }
    end

    describe "Fields in creation form" do
      it { should have_selector('#newRequest label', :text => 'Автомат') }
      it { should have_selector('#newRequest label', :text => 'Описание') }
      it { should have_selector('#newRequest label', :text => 'Телефон') }
    end
  end

end