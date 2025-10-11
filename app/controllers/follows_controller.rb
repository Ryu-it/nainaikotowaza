class FollowsController < ApplicationController
  def create
    @user = User.find(params[:user_id])
    current_user.follow(@user)
    redirect_to request.referer || root_path
  end

  def destroy
    @user = User.find(params[:user_id])
    current_user.unfollow(@user)
    redirect_to request.referer || root_path
  end
end
