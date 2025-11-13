class HomesController < ApplicationController
  def index
    @recent_proverb_titles = Proverb.order(created_at: :desc).limit(10).pluck(:title)
  end
end
