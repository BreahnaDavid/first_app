Given /^a user visits the signin page$/ do
  visit signin_path
end

When /^they submit invalid signin information$/ do
  click_button 'Sign In'
end

Then /^they should see an error message$/ do
  expect(
    have_error_message('Invalid email/password combination')
  ).to be_truthy
end

And /^the user has an account$/ do
  @user = User.create(
    name: 'Example User',
    email: 'example@mail.com',
    password: 'alohawai',
    password_confirmation: 'alohawai'
  )
end

When /^the user submit valid signin information$/ do
  fill_in 'Email', with: @user.email
  fill_in 'Password', with: @user.password
  click_button 'Sign In'
end

Then /^they should see their profile page$/ do
  expect(page).to have_content(@user.name)
  expect(page).to have_title(@user.name)
end

And /^they should see a singout link$/ do
  expect(page).to have_link('Sign Out')
end
