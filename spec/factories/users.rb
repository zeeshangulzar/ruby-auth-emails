FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password123" }
    password_confirmation { "password123" }
    confirmed_at { Time.current }
  end

  factory :unconfirmed_user, parent: :user do
    confirmed_at { nil }
  end
end
