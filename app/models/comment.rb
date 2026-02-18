class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :proverb

  has_many :reactions, as: :reactable, dependent: :destroy
  has_one :notification, as: :notifiable, dependent: :destroy

  validates :content, presence: true, length: { maximum: 300 }

  after_create :create_notification_comment

  private
  def create_notification_comment
    # コメントした本人は除外する
    recipients = proverb.users.where.not(id: user_id)
    return if recipients.blank?

    recipients.find_each do |recipient|
      Notification.find_or_create_by!(
        actor_id:      user_id,          # 通知の発火者 = コメントした自分
        recipient_id:  recipient.id,     # 受け取り手 = 相手（自分は除外済み）
        action:        :comment,
        notifiable:    self              # このコメント自体をひも付け
      )
    end
  end
end
