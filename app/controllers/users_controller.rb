class UsersController < ApplicationController
  before_action :authenticate_user!
  def index
    @q = User.ransack(params[:q])
    # 検索をした時だけ表示させる
    @users = params[:q].present? ? @q.result(distinct: true) : User.none
  end

  def show
    @user = User.find(params[:id])
    @following_count  = @user.following_users.count
    @followers_count  = @user.follower_users.count
    @proverbs = @user.proverbs.titled.recent
  end

  def following
    @user = User.find(params[:id])
    @users = @user.following_users
  end

  def followers
    @user = User.find(params[:id])
    @users = @user.follower_users
  end
end
