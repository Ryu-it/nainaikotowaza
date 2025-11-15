class Invitation < ApplicationRecord
  belongs_to :inviter, class_name: "User"
  belongs_to :invitee, class_name: "User"
  belongs_to :room

  validates :expires_at, presence: true
  validates :revoked, inclusion: { in: [ true, false ] }

  after_create :notify_invitee

  # この招待はこのユーザー用か？
  def wrong_recipient?(user)
    invitee_id.present? && invitee_id != user.id
  end

  # このユーザーがすでに部屋のメンバーか？
  def already_member?(user)
    room.users.exists?(user.id)
  end

  # 部屋 & ことわざへの参加処理をまとめる
  def add_member!(user)
    ActiveRecord::Base.transaction do
      room.room_users.create!(user:, role: :proverb_maker)

      proverb = room.proverb || room.create_proverb!(status: :draft)

      proverb.proverb_contributors.create!(user:, role: :proverb_maker)
    end
  end

  private

  def notify_invitee
    Notification.create!(
      actor:     inviter,          # 招待した人
      recipient: invitee,          # 招待された人
      action:    :invitation,
      notifiable: self
    )
  end
end
