class ProverbContributor < ApplicationRecord
  belongs_to :user
  belongs_to :proverb

  enum role: { solo: 0, word_provider: 1, proverb_maker: 2 }, _default: :solo
end
