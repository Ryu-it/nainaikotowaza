FactoryBot.define do
  factory :notification do
    association :actor, factory: :user
    association :recipient, factory: :user
    action { :follow }
    association :notifiable, factory: :follow
  end
end
