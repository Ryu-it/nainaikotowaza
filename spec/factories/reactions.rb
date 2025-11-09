FactoryBot.define do
  factory :reaction do
    association :user
    association :reactable, factory: :proverb   # デフォはProverbに付与
    kind { :like }                              # enum: { like: 0, laugh: 1, deep: 2 } など

    trait :laugh do
      kind { :laugh }
    end

    trait :deep do
      kind { :deep }
    end

    trait :for_proverb do
      association :reactable, factory: :proverb
    end

    trait :for_comment do
      association :reactable, factory: :comment
    end
  end
end
