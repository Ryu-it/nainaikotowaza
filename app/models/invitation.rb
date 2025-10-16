class Invitation < ApplicationRecord
  belongs_to :inviter, class_name: "User"
  belongs_to :invitee, class_name: "User"
  belongs_to :room

  validates :token_digest, presence: true, uniqueness: true
  validates :expires_at, presence: true
  validates :revoked, inclusion: { in: [ true, false ] }
end
