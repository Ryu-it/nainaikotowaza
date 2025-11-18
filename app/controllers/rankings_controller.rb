class RankingsController < ApplicationController
  def index
    @type = params[:type].presence_in(%w[laugh deep]) || "laugh"
    @proverbs = Proverb.ranked_by(@type)
  end
end
