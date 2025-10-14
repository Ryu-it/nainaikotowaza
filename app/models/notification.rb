class Notification < ApplicationRecord
  belongs_to :notifiable, polymorphic: true

  # 通知を送ったユーザー
  belongs_to :actor, class_name: "User"
  # 通知を受け取ったユーザー
  belongs_to :recipient, class_name: "User"

  enum action: { follow: 0, laugh: 1, deep: 2 }

  validates :actor_id, presence: true
  validates :recipient_id, presence: true
  validates :action, presence: true
  validates :notifiable_id, presence: true
  validates :notifiable_type, presence: true

  # scopeを使ってレコード取得を簡潔に
  scope :unread, -> { where(is_checked: false) }
  scope :read, -> { where(is_checked: true) }
end
