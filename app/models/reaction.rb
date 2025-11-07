class Reaction < ApplicationRecord
  belongs_to :user
  belongs_to :reactable, polymorphic: true

  enum :kind, { like: 0, laugh: 1, deep: 2 }, default: :like

  validates :user_id, presence: true
  validates :reactable_id, presence: true
  validates :reactable_type, presence: true
end
