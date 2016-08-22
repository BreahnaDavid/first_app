require 'rails_helper'


describe 'User Pages' do
  subject { page }

  describe 'signup page' do
    before { visit signup_path }

    it { is_expected.to have_content('Sign Up') }

    it { is_expected.to have_title(full_title('Sign Up')) }
  end
end
