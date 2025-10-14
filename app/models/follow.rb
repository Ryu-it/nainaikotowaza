class Follow < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

  has_one :notification, as: :notifiable, dependent: :destroy

  validates :follower_id, presence: true
  validates :followed_id, presence: true
  # 同じ人をフォローさせない
  validates :follower_id, uniqueness: { scope: :followed_id }
  # 自分自身をフォローさせない
  validate :cannot_follow_self

  # フォロー作成時に通知を作成
  after_create :create_notification_follow

  private

  def cannot_follow_self
    if follower_id == followed_id
      errors.add(:base, "自分自身をフォローすることはできません。")
    end
  end

  def create_notification_follow
    return if follower_id == followed_id

    notification = Notification.new(
      actor_id: follower_id,
      recipient_id: followed_id,
      action: :follow,
      notifiable: self
    )
    notification.save if notification.valid?
  end
end
