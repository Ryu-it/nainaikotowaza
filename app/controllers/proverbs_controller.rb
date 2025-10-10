class ProverbsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
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

  def edit
    @proverb = Proverb.find(params[:id])
  end

  def update
    @proverb = Proverb.find(params[:id])
    if @proverb.update(proverb_params)
      redirect_to proverb_path(@proverb), notice: "ことわざを編集しました"
    else
      flash.now[:alert] = "ことわざの編集に失敗しました"
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def proverb_params
    params.require(:proverb).permit(:word1, :word2, :title, :meaning, :example, :status, :room_id)
  end
end
