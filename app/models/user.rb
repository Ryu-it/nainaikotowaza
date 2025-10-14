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
  has_many :following_users, through: :active_follows, source: :followed

  # ユーザーが誰にフォローされているかのレコードを取得する(followレコードの取得)
  has_many :passive_follows, class_name: "Follow", foreign_key: "followed_id", dependent: :destroy
  # ユーザーがフォローされている人のレコードを取得する(userレコードの取得)
  has_many :follower_users, through: :passive_follows, source: :follower

  # 自分が送った通知のレコードを取得
  has_many :active_notifications, class_name: "Notification", foreign_key: "actor_id", dependent: :destroy
  # 自分が受け取った通知のレコードを取得
  has_many :passive_notifications, class_name: "Notification", foreign_key: "recipient_id", dependent: :destroy

  validates :name, presence: true, length: { maximum: 15 }

  def follow(other_user)
    unless self == other_user
      active_follows.find_or_create_by(followed_id: other_user.id)
    end
  end

  def unfollow(other_user)
    follow = active_follows.find_by(followed_id: other_user.id)
    follow&.destroy
  end

  private
  def self.ransackable_attributes(auth_object = nil)
    %w[ name ]
  end
end
