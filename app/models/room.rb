class Room < ApplicationRecord
  has_many :room_users, dependent: :destroy
  has_many :users, through: :room_users
  has_one :proverb, dependent: :destroy
  has_one :invitation, dependent: :destroy

  belongs_to :owner, class_name: "User"
end
