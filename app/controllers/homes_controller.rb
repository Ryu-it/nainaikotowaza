class HomesController < ApplicationController
  def index
    @recent_proverbs = Proverb.titled.order(created_at: :desc).limit(10)

    @recent_proverb_items =
      @recent_proverbs.includes(proverb_contributors: :user).map do |p|
        user_names =
          p.proverb_contributors
           .map { |pc| pc.user.name }
           .uniq

        {
          title: p.title,
          url: proverb_path(p),
          users: user_names
        }
      end
  end
end
