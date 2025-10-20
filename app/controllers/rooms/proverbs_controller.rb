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
      redirect_to edit_room_proverb_path(@room, @proverb), notice: "ことわざの言葉を送りました"
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
