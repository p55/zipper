# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    password { 'password' }
    password_confirmation { |u| u.password }
    email { "foo_#{SecureRandom.hex}@example.com" }
  end
end
