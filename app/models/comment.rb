class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :proverb

  has_many :reactions, as: :reactable, dependent: :destroy

  validates :content, presence: true, length: { maximum: 300 }
end
