class RoomsController < ApplicationController
  before_action :authenticate_user!

  def new
    @room = Room.new
    @q = User.ransack(params[:q])
    # 検索をした時だけ表示させる
    @users = params[:q].present? ? @q.result(distinct: true) : User.none
  end

  def create
    @q = User.ransack(params[:q])
    @users = params[:q].present? ? @q.result(distinct: true) : User.none

    user_id = params.dig(:room, :user_id)
    user    = User.find_by(id: user_id)

    unless user
      flash.now[:alert] = "ユーザーを選択してください"
      return render :new, status: :unprocessable_entity
    end

    unless current_user.following?(user)
      flash[:alert] = "フォローしているユーザーのみです"
      return redirect_back fallback_location: new_room_path
    end

    @room, @proverb, @invitation =
      Room.create_with_owner_and_invitee!(
        owner:   current_user,
        invitee: user
      )

    redirect_to edit_room_proverb_path(@room, @proverb), notice: "ルームを作成しました"

  rescue ActiveRecord::RecordInvalid
    flash.now[:alert] = "ルームの作成に失敗しました"
    render :new, status: :unprocessable_entity
  end

  def index
    @rooms = current_user.rooms
                         .joins(:proverb)
                         .merge(Proverb.where.not(status: :completed))
                         .includes(:users, :room_users)
                         .order(created_at: :desc)
  end

  private
  def room_attributes
    { owner: current_user }
  end
end
