class Proverb < ApplicationRecord
  belongs_to :room, optional: true

  has_many :proverb_contributors, dependent: :destroy
  has_many :users, through: :proverb_contributors
  has_many :comments, dependent: :destroy
  has_many :reactions, as: :reactable, dependent: :destroy

    # enumに応じたバリデーション
    validates :word1, presence: true, length: { maximum: 10 }, if: -> { in_progress? || completed? }
    validates :word2, presence: true, length: { maximum: 10 }, if: -> { in_progress? || completed? }
    validates :title, presence: true, length: { maximum: 50 }, if: :completed?
    validates :meaning, presence: true, length: { maximum: 100 }, if: :completed?
    validates :example, length: { maximum: 300 }
    validates :status, presence: true
    validates :public_uid, uniqueness: true

  enum :status, { draft: 0, in_progress: 1, completed: 2 }, default: :draft

  scope :titled, -> { where.not(title: [ nil, "" ]) }
  scope :recent, -> { order(created_at: :desc) }

  # link_to で使うために to_param をオーバーライド
  def to_param
    public_uid
  end
end
