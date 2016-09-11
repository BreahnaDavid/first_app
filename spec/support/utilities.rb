def full_title(page_title)
  base_title = 'RoR'
  if page_title.present?
    "#{base_title} | #{page_title}"
  else
    base_title
  end
end

def sign_in(user, options = {})
  if options[:capybara]
    visit signin_path
    fill_in 'Email', with: user.email.upcase
    fill_in 'Password', with: user.password
    click_button 'Sign In'
  else
    remember_token = User.new_remember_token
    cookies[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.encrypt(remember_token))
  end
end

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    expect(page).to have_selector('div.alert.alert-error', text: message)
  end
end
