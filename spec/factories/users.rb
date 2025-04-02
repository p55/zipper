FactoryBot.define do
  factory :user do
    password { 'password' }
    password_confirmation { |u| u.password }
    sequence(:email) { |n| "foo_#{n}@example.com" }
  end
end
