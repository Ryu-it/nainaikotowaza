class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :proverb

  validates :content, presence: true, length: { maximum: 300 }
end
