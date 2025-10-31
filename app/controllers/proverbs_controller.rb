class ProverbsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_params, only: %i[ edit update destroy ]
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
                      .find_by!(public_uid: params[:id])
  end

  def edit
  end

  def update
    if @proverb.update(proverb_params)
      redirect_to proverb_path(@proverb), notice: "ことわざを編集しました"
    else
      flash.now[:alert] = "ことわざの編集に失敗しました"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @proverb.destroy
    redirect_to proverbs_path, notice: "ことわざを削除しました"
    else
    render :show, alert: "削除に失敗しました"
    end
  end

  private

  def proverb_params
    params.require(:proverb).permit(:word1, :word2, :title, :meaning, :example, :status, :room_id)
  end

  def set_params
    @proverb = Proverb.find_by!(public_uid: params[:id])
  end
end
