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

      context 'should show error messages' do
        before { click_button submit }

        subject { page }

        it do
          is_expected.to have_title('Sign Up')
          is_expected.to have_content('errors')
        end
      end
    end

    context 'with valid information' do
      let(:user) { build(:user) }

      before do
        fill_in 'Name', with: user.name
        fill_in 'Email', with: user.email
        fill_in 'Password', with: user.password
        fill_in 'Confirmation', with: user.password_confirmation
      end

      it 'should create an user' do
        expect { click_button submit }.to change(
          User, :count
        ).by(1)
      end

      it 'should redirect to show page' do
        click_button submit
        expect(page).to have_title(user.name)
        expect(page).to have_selector(
          'div.alert.alert-success', text: 'Welcome'
        )
      end

      describe 'after saving the user' do
        before { click_button submit }

        let(:signed_user) { User.find_by(email: 'example@mail.com') }

        it { is_expected.to have_link('Sign Out') }

        it { is_expected.to have_title(signed_user.name) }

        it { is_expected.to have_selector('div.alert.alert-success', text: 'Welcome') }
      end
    end
  end

  describe 'edit' do
    let(:user) { create(:user) }

    before { visit edit_user_path(user) }

    describe 'page' do
      it { is_expected.to have_content('Update Your Profile') }

      it { is_expected.to have_title('Edit User') }

      it do
        is_expected.to have_link('Change', href: 'http://gravatar.com/emails')
      end
    end

    describe 'with invalid information' do
      before { click_button 'Save Changes' }

      it { is_expected.to have_content('error') }
    end
  end
end
