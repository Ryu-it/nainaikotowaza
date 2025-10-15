class UsersController < ApplicationController
  before_action :authenticate_user!
  def index
    @q = User.ransack(params[:q])
    # 検索をした時だけ表示させる
    @users = params[:q].present? ? @q.result(distinct: true) : User.none
  end
end
