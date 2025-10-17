class Proverb < ApplicationRecord
  belongs_to :room, optional: true

  has_many :proverb_contributors, dependent: :destroy
  has_many :users, through: :proverb_contributors

    # enumに応じたバリデーション
    validates :word1, presence: true, length: { maximum: 10 }, if: -> { in_progress? || completed? }
    validates :word2, presence: true, length: { maximum: 10 }, if: -> { in_progress? || completed? }
    validates :title, presence: true, length: { maximum: 50 }, if: :completed?
    validates :meaning, presence: true, length: { maximum: 100 }, if: :completed?
    validates :example, length: { maximum: 300 }
    validates :status, presence: true

  enum :status, { draft: 0, in_progress: 1, completed: 2 }, default: :draft
end
