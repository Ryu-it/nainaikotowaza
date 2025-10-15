class RoomsController < ApplicationController
  before_action :authenticate_user!

  def new
    @room = Room.new
    @q = User.ransack(params[:q])
    # 検索をした時だけ表示させる
    @users = params[:q].present? ? @q.result(distinct: true) : User.none
  end

  def create
    # 失敗した時にロールバックするためにトランザクションを使用
    user = User.find_by!(name: params.dig(:room, :user_name))
    ActiveRecord::Base.transaction do
      @room = Room.new(room_params)
      @room.save!
      # RoomUserを2つ作成する
      @room.room_users.create!(user: current_user, role: :word_giver)
      @room.room_users.create!(user: user, role: :proverb_maker)
    end
    redirect_to new_room_proverb_path(@room), notice: "ルームを作成しました"

  rescue ActiveRecord::RecordInvalid
    flash.now[:alert] = "ルームの作成に失敗しました"
    render :new, status: :unprocessable_entity
  end

  private
  def room_params
    params.require(:room).permit(:name).merge(owner: current_user)
  end
end
