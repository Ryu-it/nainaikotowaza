class ReactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_reactable

  def create
    @reaction = @reactable.reactions.find_or_initialize_by(
      user: current_user,
      kind: params[:kind]
    )
    if @reaction.save
      redirect_back(fallback_location: root_path)
    else
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    @reaction = @reactable.reactions.find(params[:id])
    @reaction.destroy!
    redirect_back(fallback_location: root_path)
  end

  private

  # どのモデルにリアクションをつけるかを判定
  def set_reactable
    if params[:comment_id]
      @reactable = Comment.find(params[:comment_id])
    elsif params[:proverb_id]
      # :proverb_id には public_uid が入ってくる
      @reactable = Proverb.find_by!(public_uid: params[:proverb_id])
    else
      raise ActiveRecord::RecordNotFound
    end
  end
end
