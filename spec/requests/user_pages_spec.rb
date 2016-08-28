require 'rails_helper'


describe 'User Pages' do
  subject { page }

  describe 'signup page' do
    before { visit signup_path }

    it { is_expected.to have_content('Sign Up') }

    it { is_expected.to have_title(full_title('Sign Up')) }
  end

  describe 'profile page' do
    before do
      @user = create(:user)
      visit user_path(@user)
    end

    it { is_expected.to have_content(@user.name) }

    it { is_expected.to have_title(@user.name) }
  end

  describe 'sign up' do

    before { visit signup_path }

    let(:submit) { 'Create my account' }

    context 'with invalid information' do
      it 'should not create an user' do
        expect{ click_button  submit }.not_to change(User, :count)
      end
    end

    context 'with valid information' do
      it 'should create an user' do
        user = build(:user)
        fill_in 'Name', with: user.name
        fill_in 'Email', with: user.email
        fill_in 'password', with: user.password
        fill_in 'password_confirmation', with: user.password_confirmation

        expect{ click_button submit }.to change(User, :count).by(1)
      end
    end
  end
end
