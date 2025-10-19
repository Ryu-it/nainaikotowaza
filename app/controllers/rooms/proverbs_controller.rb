class Rooms::ProverbsController < ApplicationController
  before_action :authenticate_user!
  def new
    @room = Room.find(params[:room_id])
    @proverb = @room.build_proverb
    @proverb_maker_name = @room.room_users.find_by(role: :proverb_maker)&.user&.name
  end

  def create
    @room = Room.find(params[:room_id])
    @proverb = @room.build_proverb(proverb_params)
    if @proverb.save
      redirect_to edit_room_proverb_path(@room, @proverb), notice: "ことわざの言葉を送りました"
    else
      flash.now[:alert] = "ことわざの言葉の投稿に失敗しました"
      render :new, status: :unprocessable_entity
    end
  end

  private
  def proverb_params
    params.require(:proverb).permit(:word1, :word2, :title, :meaning, :example, :status)
  end
end
