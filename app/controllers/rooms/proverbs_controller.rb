class Rooms::ProverbsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_room, only: %i[edit update]

  def edit
    @proverb = @room.proverb
  end

  def update
    @proverb = @room.proverb

    @proverb.assign_attributes(proverb_params)

    if @proverb.save
      case @room.role_for(current_user)
      when "word_giver"
        redirect_to rooms_path, notice: "ことわざの言葉を送りました"
      when "proverb_maker"
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

  def set_room
    @room = Room.find(params[:room_id])
  end
end
