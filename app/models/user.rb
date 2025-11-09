class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable,
         :omniauthable, omniauth_providers: %i[ google_oauth2 line ]

  has_many :owner, class_name: "Room", foreign_key: "owner_id", dependent: :destroy
  has_many :proverb_contributors, dependent: :destroy
  has_many :proverbs, through: :proverb_contributors
  has_many :room_users, dependent: :destroy
  has_many :rooms, through: :room_users
  has_many :comments, dependent: :destroy
  has_many :reactions, dependent: :destroy

  # プロフィール画像のアップロード
  has_one_attached :avatar

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

  # 自分が送った招待のレコードを取得
  has_many :sent_invitations, class_name: "Invitation", foreign_key: "inviter_id", dependent: :destroy
  # 自分が受け取った招待のレコードを取得
  has_many :received_invitations, class_name: "Invitation", foreign_key: "invitee_id", dependent: :destroy

  validates :name, presence: true, length: { maximum: 15 }

  validates :uid, presence: true, uniqueness: { scope: :provider }, if: -> { uid.present? }

  validate :avatar_size
  validate :avatar_type

  # lineの時はemail不要
  def email_required?
    provider != "line"
  end

  def follow(other_user)
    return if self == other_user
    active_follows.find_or_create_by(followed_id: other_user.id)
  end

  def unfollow(other_user)
    follow = active_follows.find_by(followed_id: other_user.id)
    follow&.destroy
  end

  # other_user を自分がフォローしているかどうか
  def following?(other_user)
    following_users.include?(other_user)
  end

  # uidをランダムに生成して返す
  def self.create_unique_string
    SecureRandom.uuid
  end

  # OAuth認証でユーザー情報を取得
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name
    end
  end

  private
  def self.ransackable_attributes(auth_object = nil)
    %w[ name ]
  end

  # avatarのサイズを制限
  def avatar_size
    if avatar.attached? && avatar.blob.byte_size > 10.megabytes
      errors.add(:avatar, "10MB以下にしてください")
    end
  end

  # avatarの形式を制限
  def avatar_type
    if avatar.attached? && !avatar.blob.content_type.in?(%w[ image/jpeg image/png image/jpg ])
      errors.add(:avatar, "JPEG、PNG、JPG形式にしてください")
    end
  end
end
