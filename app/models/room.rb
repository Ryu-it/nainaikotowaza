class Room < ApplicationRecord
  has_many :room_users, dependent: :destroy
  has_many :users, through: :room_users
  has_one :proverb, dependent: :destroy
  has_one :invitation, dependent: :destroy

  belongs_to :owner, class_name: "User"

  def self.create_with_owner_and_invitee!(owner:, invitee:)
    transaction do
      room = Room.create!(owner: owner)

      room.room_users.create!(user: owner, role: :word_giver)

      proverb = room.create_proverb!(status: :draft)
      proverb.proverb_contributors.create!(user: owner, role: :word_giver)

      # 招待を作成
      invitation = Invitation.create!(
        inviter:   owner,
        invitee:   invitee,
        room:      room,
        expires_at: 3.days.from_now,
        revoked:   false
      )

      [ room, proverb, invitation ]
    end
  end
end
