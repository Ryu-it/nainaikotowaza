FactoryBot.define do
  factory :room do
    association :owner, factory: :user

    after(:create) do |room|
      create(:proverb, room: room)
      create(:room_user, room: room, role: :word_giver)
      create(:room_user, room: room, role: :proverb_maker)
    end
  end
end
