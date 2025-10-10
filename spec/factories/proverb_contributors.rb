FactoryBot.define do
  factory :proverb_contributor do
  association :user
  association :proverb
  end
end
