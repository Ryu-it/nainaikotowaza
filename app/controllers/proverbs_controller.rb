class ProverbsController < ApplicationController
  def new
    @proverb = Proverb.new
  end

  def create
    @proverb = current_user.proverbs.build(proverb_params)
    if @proverb.save
      redirect_to root_path, notice: "ことわざを登録しました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def proverb_params
    params.require(:proverb).permit(:word1, :word2, :title, :meaning, :example, :status, :room_id)
  end
end
