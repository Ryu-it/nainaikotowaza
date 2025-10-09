class ProverbsController < ApplicationController
  def new
    @proverb = Proverb.new
  end

  def create
    # 失敗した時にロールバックするためにトランザクションを使用
    ActiveRecord::Base.transaction do
      @proverb = Proverb.new(proverb_params)
      @proverb.save!
      @proverb.proverb_contributors.create!(user: current_user, role: :solo)
    end

    redirect_to proverbs_path, notice: "ことわざを投稿しました"
    rescue ActiveRecord::RecordInvalid
      flash.now[:alert] = "ことわざの投稿に失敗しました"
      render :new, status: :unprocessable_entity
  end

  def index
    @proverbs = Proverb.includes(proverb_contributors: :user)
                       .order(created_at: :desc)
  end

  def show
    @proverb = Proverb.includes(proverb_contributors: :user)
                      .find(params[:id])
  end

  private

  def proverb_params
    params.require(:proverb).permit(:word1, :word2, :title, :meaning, :example, :status, :room_id)
  end
end
