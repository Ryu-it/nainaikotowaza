class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!
  def term
  end

  def privacy
  end

  def usage
  end
end
