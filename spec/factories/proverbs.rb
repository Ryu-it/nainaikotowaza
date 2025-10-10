FactoryBot.define do
  factory :proverb do
    word1 { "MyString" }
    word2 { "MyString" }
    title { "MyString" }
    meaning { "MyString" }
    example { "MyText" }
    status { 1 }
    room { nil }

    after(:create) do |proverb|
      create(:proverb_contributor, proverb: proverb)
    end
  end
end
