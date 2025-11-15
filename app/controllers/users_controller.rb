class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[show following followers]

  def index
    @q = User.ransack(params[:q])
    # 検索をした時だけ表示させる
    @users = params[:q].present? ? @q.result(distinct: true) : User.none
  end

  def show
    @following_count  = @user.following_users.count
    @followers_count  = @user.follower_users.count
    @proverbs = @user.proverbs.titled.recent
  end

  def following
    @users = @user.following_users
  end

  def followers
    @users = @user.follower_users
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
