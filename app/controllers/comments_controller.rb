class CommentsController < ApplicationController
  before_action :set_proverb

  def create
    @comment = @proverb.comments.build(comment_params)
    # user_id カラムに現在のユーザーのIDを設定
    @comment.user = current_user

    respond_to do |format|
      if @comment.save
        format.turbo_stream
        format.html { redirect_to @proverb }
      else
        format.html { redirect_to @proverb, alert: "コメントの投稿に失敗しました。" }
      end
    end
  end

  def destroy
    @comment = @proverb.comments.find(params[:id])
    @comment.destroy
    redirect_to @proverb, notice: "コメントを削除しました。"
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

  def set_proverb
    @proverb = Proverb.find_by!(public_uid: params[:proverb_id])
  end
end
