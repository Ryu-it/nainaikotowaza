class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :owner, class_name: "Room", foreign_key: "owner_id", dependent: :destroy
  has_many :proverb_contributors, dependent: :destroy
  has_many :proverbs, through: :proverb_contributors

  validates :name, presence: true, length: { maximum: 15 }
end
