FactoryBot.define do
  factory :room do
    association :owner, factory: :user

    trait :with_members_for do
      transient do
        inviter { nil }   # ← owner にあたる人
        invitee { nil }   # ← 招待された人
      end

      after(:create) do |room, evaluator|
        create(:proverb, room: room)

        inviter_user = evaluator.inviter || create(:user)
        invitee_user = evaluator.invitee || create(:user)

        create(:invitation, room: room, inviter: inviter_user, invitee: invitee_user)

        create(:room_user, room: room, user: inviter_user, role: :word_giver)
        create(:room_user, room: room, user: invitee_user, role: :proverb_maker)
      end
    end
  end
end
