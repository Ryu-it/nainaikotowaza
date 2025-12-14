FactoryBot.define do
  factory :user do
    name                  { "test" }
    sequence(:email)      { |n| "test#{n}@gmail.com" }
    password              { "12345678" }
    password_confirmation { "12345678" }
    uid { SecureRandom.uuid }

    # 誰かをフォローした状態
    trait :with_active_follows do
      after(:create) do |user|
      other_user = create(:user)
      create(:follow, follower: user, followed: other_user)
      end
    end
  end
end
