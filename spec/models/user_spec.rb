require 'rails_helper'

describe User do
  before do
    @user = User.new(
      name: 'Adomnita Ion',
      email: 'ion@gmail.com',
      password: 'asda123',
      password_confirmation: 'asda123',
    )
  end

  subject { @user }

  it { is_expected.to respond_to(:name) }

  it { is_expected.to respond_to(:email) }

  it { is_expected.to respond_to(:password_digest) }

  it { is_expected.to respond_to(:password) }

  it { is_expected.to respond_to(:password_confirmation) }

  it { is_expected.to respond_to(:authenticate) }

  it { is_expected.to be_valid }
 
  context 'name is not present' do
    before { @user.name = ' ' }

    it { is_expected.not_to be_valid }
  end 

  context 'email is not present' do
    before { @user.email = ' ' }

    it { is_expected.not_to be_valid }
  end 

  context 'name is too long' do
    before { @user.name = 'a' * 51 }

    it { is_expected.not_to be_valid }
  end 

  context 'email format is invalid' do
    it do
      addresses = [
        'user@foo,com',
        'user_at_foo.org',
        'example.user@foo.foo@bar_baz.com',
        'foo@bar+baz.com',
      ]
      addresses.each do |address|
        @user.email = address
        is_expected.not_to be_valid
      end
    end
  end

  context 'email format is valid' do
    it do
      addresses = [
        'user@foo.COM',
        'A_US-ER@f.b.org',
        'frst.lst@foo.jp',
        'a+b@baz.cn',
      ]
      addresses.each do |address|
        @user.email = address
        is_expected.to be_valid
      end
    end
  end

  context 'email already exists' do
    before do
      copy_of_user = @user.dup
      copy_of_user.email = @user.email.upcase
      copy_of_user.save
    end

    it { is_expected.not_to be_valid }
  end

  context 'email should be saved in downcase' do
    it do
      mixed_email ='FOO@example.COM' 
      @user.email = mixed_email
      @user.save
      expect(@user.reload.email).to eq mixed_email.downcase
    end
  end

  context 'password is not present' do
    before do
      @user.password = ''
      @user.password_confirmation = ''
    end

    it { is_expected.not_to be_valid }
  end

  context "password doesn't match confirmation" do
    before { @user.password_confirmation = nil }

    it { is_expected.not_to be_valid }
  end

  context 'password to shoort' do
    before do
      @user.password = 'a' * 5
      @user.password_confirmation = @user.password
    end

    it { is_expected.not_to be_valid }
  end

  describe '#authenticate' do
    before { @user.save }

    let(:found_user) { User.find_by(email: @user.email) }

    it 'with valid password' do
      is_expected.to eq(
        found_user.authenticate(@user.password)
      )
    end

    it 'with invalid password' do
      found_invalid_user = found_user.authenticate('invalid')

      expect(found_invalid_user).to be_falsey
    end
  end
end
