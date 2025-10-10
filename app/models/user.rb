class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :owner, class_name: "Room", foreign_key: "owner_id", dependent: :destroy
  has_many :proverb_contributors, dependent: :destroy
  has_many :proverbs, through: :proverb_contributors

  # ユーザーが誰をフォローしているかのレコードを取得する(followレコードの取得)
  has_many :active_follows, class_name: "Follow", foreign_key: "follower_id", dependent: :destroy
  # ユーザーがフォローしている人のレコードを取得する(userレコードの取得)
  has_many :following, through: :active_follows, source: :followed
  # ユーザーが誰にフォローされているかのレコードを取得する(followレコードの取得)
  has_many :passive_follows, class_name: "Follow", foreign_key: "followed_id", dependent: :destroy
  # ユーザーがフォローされている人のレコードを取得する(userレコードの取得)
  has_many :followers, through: :passive_follows, source: :follower

  validates :name, presence: true, length: { maximum: 15 }
end
