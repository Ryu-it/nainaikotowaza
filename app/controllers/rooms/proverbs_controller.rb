class Rooms::ProverbsController < ApplicationController
  before_action :authenticate_user!

  def edit
    @room = Room.find(params[:room_id])
    @proverb = @room.proverb
  end

  def update
    @room    = Room.find(params[:room_id])
    @proverb = @room.proverb

    @proverb.assign_attributes(proverb_params)

    if @proverb.save
      # 👇 current_user の役割を判定して遷移先を分ける
      if @room.room_users.exists?(user_id: current_user.id, role: :word_giver)
        redirect_to root_path, notice: "ことわざの言葉を送りました"
      elsif @room.room_users.exists?(user_id: current_user.id, role: :proverb_maker)
        redirect_to proverbs_path, notice: "ことわざを作成しました"
      else
        redirect_to root_path, alert: "権限がありません"
      end
    else
      flash.now[:alert] = "更新に失敗しました"
      render :edit, status: :unprocessable_entity
    end
  end

  private
  def proverb_params
    params.require(:proverb).permit(:word1, :word2, :title, :meaning, :example, :status)
  end
end
