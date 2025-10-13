FactoryBot.define do
  factory :proverb do
    word1 { "MyString" }
    word2 { "MyString" }
    title { "MyString" }
    meaning { "MyString" }
    example { "MyText" }
    status { 1 }
    room { nil }

    transient do
      owner { nil }   # ← 追加：紐づけたいユーザーを受け取る
    end

    after(:create) do |proverb, evaluator|
      create(
        :proverb_contributor,
        proverb: proverb,
        user: evaluator.owner || create(:user) # 渡されなければ新規ユーザー
      )
    end
  end
end
