class Invitation < ApplicationRecord
  belongs_to :inviter, class_name: "User"
  belongs_to :invitee, class_name: "User"
  belongs_to :room

  validates :expires_at, presence: true
  validates :revoked, inclusion: { in: [ true, false ] }

  def invalid?
    expires_at.past? || revoked?
  end
end
