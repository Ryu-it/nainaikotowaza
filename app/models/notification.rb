class Notification < ApplicationRecord
  belongs_to :notifiable, polymorphic: true

  # 通知を送ったユーザー
  belongs_to :actor, class_name: "User"
  # 通知を受け取ったユーザー
  belongs_to :recipient, class_name: "User"

  enum :action, { follow: 0, invitation: 1, reaction: 2, comment: 3 }

  validates :actor_id, presence: true
  validates :recipient_id, presence: true
  validates :action, presence: true
  validates :notifiable_id, presence: true
  validates :notifiable_type, presence: true
  validates :is_checked, inclusion: { in: [ true, false ] }

  # scopeを使って通知の閲覧の有無を簡潔に
  scope :unread, -> { where(is_checked: false) }
  scope :read, -> { where(is_checked: true) }

  # scopeを使って招待モデルを簡潔に取得
  scope :invitations, -> { where(notifiable_type: "Invitation") }
  scope :excluding_invitations, -> { where.not(notifiable_type: "Invitation") }
end
