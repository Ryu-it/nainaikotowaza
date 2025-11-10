# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


require "faker"

return unless Rails.env.development? # 本番で実行されないようにする

# ---- ユーザーを10人作成して配列で受け取る ----
users = 10.times.map do
  User.create!(
    name:  Faker::Name.name,
    email: Faker::Internet.unique.email,
    password: "password",
    password_confirmation: "password"
  )
end

# fakerを使ってことわざを20個作成する
20.times do
  proverb = Proverb.create!(
    word1: Faker::Verb.base.capitalize,
    word2: Faker::Emotion.noun.capitalize,
    title: Faker::Quote.famous_last_words,
    meaning: Faker::Lorem.sentence(word_count: 10),
    example: Faker::Lorem.sentence(word_count: 20),
    status: :in_progress,
    room: nil
  )

  # ランダムなユーザーを1人〜2人紐づける
  rand(1..2).times do
    ProverbContributor.create!(
      proverb: proverb,
      user: users.sample
    )
  end
end
