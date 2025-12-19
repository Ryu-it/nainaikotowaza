class RankingsController < ApplicationController
  skip_before_action :authenticate_user!
  def index
    @type = params[:type].presence_in(%w[laugh deep]) || "laugh"
    @proverbs = Proverb.ranked_by(@type)
  end
end
