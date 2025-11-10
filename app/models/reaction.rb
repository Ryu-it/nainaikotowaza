class Reaction < ApplicationRecord
  belongs_to :user
  belongs_to :reactable, polymorphic: true

  has_one :notification, as: :notifiable, dependent: :destroy

  enum :kind, { like: 0, laugh: 1, deep: 2 }, default: :like

  validates :user_id, presence: true
  validates :reactable_id, presence: true
  validates :reactable_type, presence: true

  after_create :create_notification_reaction

  private

  def create_notification_reaction
    case reactable
    when Proverb
      # ことわざのリアアクションには複数の投稿者にいく
      reactable.users.where.not(id: user_id).find_each do |recipient|
        Notification.find_or_create_by!(
          actor_id: user_id,
          recipient_id: recipient.id,
          action: :reaction,
          notifiable: self
        )
      end

    when Comment
      # コメントのリアクションはコメント投稿者にだけいく
      return if user_id == reactable.user_id

      Notification.find_or_create_by!(
        actor_id: user_id,
        recipient_id: reactable.user_id,
        action: :reaction,
        notifiable: self
      )
    end
  end
end
