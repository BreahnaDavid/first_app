require 'rails_helper'

describe 'Authentication' do
  subject { page }

  describe 'signin page' do
    before { visit signin_path }

    it { is_expected.to have_content('Sign In') }

    it { is_expected.to have_title('Sign In') }
  end

  describe 'signin' do
    before { visit signin_path }

    describe 'with invalid information' do
      before { click_button 'Sign In' }

      it { is_expected.to have_title('Sign In') }

      it { is_expected.to have_selector('div.alert.alert-error') }

      describe "after visiting another page" do
        before { click_link "Home" }

        it { should_not have_selector('div.alert.alert-error') }
      end
    end

    describe 'with valid information' do
      let(:user) { create(:user) }

      before do
        fill_in 'Email', with: user.email.upcase
        fill_in 'Password', with: user.password
        click_button 'Sign In'
      end

      it { is_expected.to have_title(user.name) }

      it { is_expected.to have_link('Profile', href: user_path(user)) }

      it { is_expected.to have_link('Sign Out', href: signout_path) }

      it { is_expected.not_to have_link('Sign In', href: signin_path) }

      describe 'followed by sing out ' do
        before { click_link 'Sign Out' }

        it { is_expected.to have_link('Sign In') }
      end
    end
  end
end
