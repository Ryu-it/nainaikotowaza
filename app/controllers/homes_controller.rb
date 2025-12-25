class HomesController < ApplicationController
  skip_before_action :authenticate_user!
  def index
    @recent_proverbs = Proverb.recent_limit_10

    @recent_proverb_items =
      @recent_proverbs.includes(proverb_contributors: :user).map do |p|
        user_names =
          p.proverb_contributors
           .map { |pc| pc.user.name }

        {
          title: p.title,
          url: proverb_path(p),
          users: user_names
        }
      end
  end
end
