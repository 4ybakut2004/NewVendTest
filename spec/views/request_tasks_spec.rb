require 'spec_helper'

describe "Request Tasks pages" do
  before { sign_in_user }
  subject { page }

  describe "Index page" do
    before { visit request_tasks_path }

    it { should have_title('Request Tasks') }

    describe "Content on page" do
        it { should have_content('Поручения') }
    end

    describe "Buttons on page" do
        it { should have_selector('button', :text => 'Назначатель') }
        it { should have_selector('button', :text => 'Исполнитель') }
        it { should have_selector('button', :text => 'Контролер') }
        it { should have_selector('button', :text => 'Назначить') }
        it { should have_selector('button', :text => 'Выполнить') }
        it { should have_selector('button', :text => 'Проконтролировать') }
        it { should have_selector('button', :text => 'Просрочены и сделаны') }
        it { should have_selector('button', :text => 'Просрочены и не сделаны') }
    end

    describe "Columns in main grid" do
        it { should have_selector('thead th', :text => 'Номер') }
        it { should have_selector('thead th', :text => 'Тип') }
        it { should have_selector('thead th', :text => 'Назначатель') }
        it { should have_selector('thead th', :text => 'Исполнитель') }
        it { should have_selector('thead th', :text => 'Контролер') }
        it { should have_selector('thead th', :text => 'Описание') }
        it { should have_selector('thead th', :text => 'Дата создания') }
        it { should have_selector('thead th', :text => 'Плановая дата') }
        it { should have_selector('thead th', :text => 'Дата выполнения') }
        it { should have_selector('thead th', :text => 'Дата проверки') }
    end
  end


end