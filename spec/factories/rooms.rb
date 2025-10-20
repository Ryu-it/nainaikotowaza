FactoryBot.define do
  factory :room do
    association :owner, factory: :user

    trait :with_members_for do
      transient do
        current_user { nil }      # ← 渡さなければ自動生成にフォールバック
        invited_user { nil }      # ← 渡さなければ自動生成にフォールバック
      end

      after(:create) do |room, evaluator|
        create(:proverb, room: room)

        wg_user = evaluator.current_user || create(:user)
        pm_user = evaluator.invited_user || create(:user)

        create(:room_user, room: room, user: wg_user, role: :word_giver)
        create(:room_user, room: room, user: pm_user, role: :proverb_maker)
      end
    end
  end
end
