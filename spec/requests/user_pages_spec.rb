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

        let(:signed_user) { User.find_by(email: user.email) }

        it { is_expected.to have_link('Sign Out') }

        it { is_expected.to have_title(signed_user.name) }

        it { is_expected.to have_selector('div.alert.alert-success', text: 'Welcome') }
      end
    end
  end

  describe 'edit' do
    let(:user) { create(:user) }

    before do
      sign_in user, capybara: true
      visit edit_user_path(user)
    end

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

    describe 'with valid information' do
      let(:new_name) { 'Habr Name' }

      let(:new_email) { 'new@habrahabr.com' }

      before do
        fill_in 'Name', with: new_name
        fill_in 'Email', with: new_email
        fill_in 'Password', with: user.password
        fill_in 'Confirmation', with: user.password
        click_button 'Save Changes'
      end

      it { is_expected.to have_title(new_name) }

      it { is_expected.to have_selector('div.alert.alert-success') }

      it { is_expected.to have_link('Sign Out', href: signout_path) }

      specify { expect(user.reload.name).to  eq new_name }

      specify { expect(user.reload.email).to eq new_email }
    end

    describe 'forbidden attributes' do
      let(:params) do
        {
          user: {
            admin: true,
            password: user.password,
            password_confirmation: user.password 
          }
        }
      end

      before do
        patch user_path(user), params
      end

      it { expect(user.reload).not_to be_admin }
    end
  end

  describe 'index' do
    let(:user) { create(:user) }

    before do
      sign_in user, capybara: true
      visit users_path
    end

    it { is_expected.to have_title('All Users') }

    it { is_expected.to have_selector('h1', text: 'All Users') }

    describe 'pagination' do
      before(:all) { 30.times { create(:user) } }
      after(:all) { User.delete_all }

      it { is_expected.to have_selector('div.pagination') }

      it 'should list each user' do
        User.paginate(page: 1).each do |user|
          is_expected.to have_selector('li', text: user.name)
        end
      end
    end

    describe 'delete links' do
      it { is_expected.not_to have_link('Delete') }

      describe 'as an admin user' do
        let(:admin) { create(:admin) }

        before do
          sign_in admin, capybara: true
          visit users_path
        end

        it do
          is_expected.to have_link(
            'Delete',
            href: user_path(User.first)
          )
        end

        it 'should be able to delete another user' do
          expect do
            click_link('Delete', match: :first)
          end.to change(User, :count).by(-1)
        end

        it do
          is_expected.not_to have_link(
            'Delete',
            href: user_path(admin)
          )
        end
      end
    end
  end
end
