FactoryBot.define do
  factory :comment do
    association :user
    association :proverb
    content { "This is a sample comment." }
  end
end
