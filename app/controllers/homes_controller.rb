class HomesController < ApplicationController
  def index
    @recent_proverbs = Proverb.order(created_at: :desc).limit(10)

    @recent_proverb_items = @recent_proverbs.map do |p|
      {
        title: p.title,
        url:   proverb_path(p) # or proverb_url(p)（絶対URLが欲しければこっち）
      }
    end
  end
end
