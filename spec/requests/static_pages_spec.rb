require 'spec_helper'
require 'sessions_helper'

describe "Static pages" do
  subject { page }

  describe "Home page" do
    before { visit root_path  }
    it { should have_content('Новый Вендинг') }
    it { should have_title('New Vending') }

    it { should_not have_content('Выйти') }
    it { should have_content('Войти') }
  end

  it "should have the right links on the layout" do
    sign_in_user

    visit root_path
    expect(page).to have_content('Выйти')

    click_link "Главная"
    expect(page).to have_title('New Vending')

    first(:link, "Заявки").click
    expect(page).to have_title('| Requests')

    first(:link, "Поручения").click
    expect(page).to have_title('| Request Tasks')

    first(:link, "Автоматы").click
    expect(page).to have_title('| Machines')

    first(:link, "Типы заявок").click
    expect(page).to have_title('| Request Types')

    first(:link, "Типы сигналов").click
    expect(page).to have_title('| Messages')

    first(:link, "Типы поручений").click
    expect(page).to have_title('| Tasks')

    first(:link, "Типы атрибутов").click
    expect(page).to have_title('| Attributes')

    first(:link, "Пользователи").click
    expect(page).to have_title('| Users')

    first(:link, "Сотрудники").click
    expect(page).to have_title('| Employees')

  end

end