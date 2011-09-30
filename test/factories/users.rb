FactoryGirl.define do
  sequence :email do |n|
    "email#{n}@example.com"
  end

  factory :user do
    email { Factory.next(:email) }
    password 'blah1234'
    encrypted_password '123456'
  end
end
