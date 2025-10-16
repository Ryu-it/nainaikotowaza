FactoryBot.define do
  factory :room_user do
    association :room
    association :user
    role { :word_giver }
  end
end
