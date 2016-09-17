FactoryGirl.define do
  factory :user do
    sequence(:id)
    sequence(:name) { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com" }
    password 'foobar'
    password_confirmation { password }

    factory :admin do
      admin true
    end
  end
end
