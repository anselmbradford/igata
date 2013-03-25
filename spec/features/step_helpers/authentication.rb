def sign_in_with(account)
  visit sign_in_path
  fill_in 'Email', :with => account.email
  fill_in 'Password', :with => account.password
  click_button 'Sign in'

  self.current_account = account
end

def current_account
  @current_account
end

def current_account=(account)
  @current_account = account
end
