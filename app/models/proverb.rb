class Proverb < ApplicationRecord
  belongs_to :room, optional: true

  has_many :proverb_contributors, dependent: :destroy
  has_many :users, through: :proverb_contributors

  validates :word1, presence: true, length: { maximum: 10 }
  validates :word1, presence: true, length: { maximum: 10 }
  validates :title, presence: true, length: { maximum: 50 }
  validates :meaning, presence: true, length: { maximum: 100 }
  validates :example, length: { maximum: 300 }
  validates :status, presence: true

  enum :status, { in_progress: 0, completed: 1 }, default: :in_progress
end
