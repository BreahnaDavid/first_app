require 'rails_helper'

describe User do
  before do
    @user = User.new(
      name: 'Adomnita Ion',
      email: 'ion@gmail.com',
    )
  end

  subject { @user }

  it { is_expected.to respond_to(:name) }

  it { is_expected.to respond_to(:email) }

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
end
