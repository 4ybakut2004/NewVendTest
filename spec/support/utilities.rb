def sign_in(user, options={})
  if options[:no_capybara]
    # Sign in when not using Capybara.
    remember_token = User.new_remember_token
    cookies[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.encrypt(remember_token))
  else
    visit signin_path
    fill_in "session_name",    with: user.name
    fill_in "session_password", with: user.password_digest
    click_button "Войти"
  end
end

def current_user
  remember_token = User.encrypt(cookies[:remember_token])
  @current_user ||= User.find_by(remember_token: remember_token)
end

def sign_in_user
    @employee = Employee.create(:name => "Employee")
    @user = User.create(:name => "User", :password_digest => "password", :employee_id => @employee.id)
    sign_in @user 
end