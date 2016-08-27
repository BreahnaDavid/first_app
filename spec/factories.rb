FactoryGirl.define do
  factory :user do
    sequence(:id)
    name 'Test User'
    email 'example@mail.com'
    password 'foobar'
    password_confirmation { password }
  end
end
