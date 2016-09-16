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
        sign_in(user, capybara: true)
      end

      it { is_expected.to have_title(user.name) }

      it { is_expected.to have_link('Profile', href: user_path(user)) }

      it { is_expected.to have_link('Settings', href: edit_user_path(user)) }

      it { is_expected.to have_link('Sign Out', href: signout_path) }

      it { is_expected.not_to have_link('Sign In', href: signin_path) }

      describe 'followed by sing out ' do
        before { click_link 'Sign Out' }

        it { is_expected.to have_link('Sign In') }
      end
    end

    describe 'authorization' do
      describe 'for non-signed users' do
        let(:user) { create(:user) }

        describe 'in the users controller' do
          describe 'visiting the edit page' do
            before { visit edit_user_path(user) }

            it { is_expected.to have_title('Sign In') }
          end

          describe 'submitting to the update action' do
            before { patch user_path(user) }

            it { expect(response).to redirect_to(signin_path) }
          end
        end

        describe 'after signin in' do
          before do
            visit edit_user_path(user)
            fill_in 'Email', with: user.email
            fill_in 'Password', with: user.password
            click_button 'Sign In'
          end

          it { is_expected.to have_title('Edit User') }
        end
      end

      describe 'as wrong user' do
        let(:user) { create(:user) }

        let(:wrong_user) { create(:user, email: 'wrong@example.com') }

        before { sign_in user }

        describe 'submitting a GET request to the Users#edit action' do
          before { get edit_user_path(wrong_user) }

          it { expect(response.body).not_to include(full_title('Edit User')) }

          it { expect(response).to redirect_to(root_path) }
        end

        describe 'submitting a PATCH request to the Users#update action' do
          before { patch user_path(wrong_user) }

          it { expect(response).to redirect_to(root_path) }
        end
      end
    end
  end
end
