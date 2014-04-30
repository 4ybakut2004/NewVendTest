require 'spec_helper'

describe "Messages pages" do
  before { sign_in_user }
  subject { page }

  describe "Index page" do
    before { visit messages_path }

    it { should have_title('Messages') }

    describe "Content on page" do
      it { should have_content('Типы сигналов') }
      it { should have_content('Новый тип сигнала') }
    end

    describe "Buttons on page" do
      it { should have_selector('button', :text => 'Создать') }
      it { should have_selector('button', :text => 'Удалить') }
    end

    describe "Columns in main grid" do
      it { should have_selector('thead th', :text => 'Номер') }
      it { should have_selector('thead th', :text => 'Наименование') }
      it { should_not have_selector('thead th', :text => 'Решатель') }
      it { should have_selector('thead th', :text => 'Описание') }
    end

    describe "Fields in creation form" do
      it { should have_selector('#newMessage label', :text => 'Наименование') }
      it { should_not have_selector('#newMessage label', :text => 'Решатель') }
      it { should have_selector('#newMessage label', :text => 'Описание') }
    end
  end


end