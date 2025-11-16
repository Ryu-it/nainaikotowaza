FactoryBot.define do
  factory :invitation do
    association :room
    association :inviter, factory: :user
    association :invitee, factory: :user

    expires_at { 3.days.from_now }
    revoked    { false }
  end
end
