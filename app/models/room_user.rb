class RoomUser < ApplicationRecord
  belongs_to :room
  belongs_to :user

  enum :role, { word_giver: 0, proverb_maker: 1 }, default: :word_given

  validates :role, presence: true
end
