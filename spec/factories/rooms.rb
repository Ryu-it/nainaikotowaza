FactoryBot.define do
  factory :room do
    association :owner, factory: :user

    trait :with_members_for do
      transient { current_user { nil } }
      after(:create) do |room, evaluator|
        create(:proverb, room: room)
        create(:room_user, room: room, user: evaluator.current_user || create(:user), role: :word_giver)
        create(:room_user, room: room, role: :proverb_maker)
      end
    end
  end
end
