class Rooms::ProverbsController < ApplicationController
  before_action :authenticate_user!
  def new
    @room = Room.find(params[:room_id])
    @proverb = @room.build_proverb
  end

  def create
    @room = Room.find(params[:room_id])
    @proverb = @room.build_proverb(proverb_params)
    if @proverb.save
      redirect_to edit_room_proverb_path(@room, @proverb), notice: "ことわざの言葉を送りました"
    else
      render :new, alert: "ことわざの言葉の投稿に失敗しました"
    end
  end

  private
  def proverb_params
    params.require(:proverb).permit(:word1, :word2, :title, :meaning, :example, :status)
  end
end
