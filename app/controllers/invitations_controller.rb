class InvitationsController < ApplicationController
  before_action :authenticate_user!

  def accept
    invitation = Invitation.find_signed!(params[:token], purpose: :invite)
    room       = invitation.room

    # この招待はこのユーザー用か？
    if invitation.wrong_recipient?(current_user)
      redirect_to root_path, alert: "この招待リンクは無効です"
      return
    end

    # このユーザーがすでに部屋のメンバーか？
    if invitation.already_member?(current_user)
      redirect_to rooms_path, notice: "すでにこの部屋のメンバーです。「進行中の部屋」からアクセスしてください。"
      return
    end

    # 部屋 & ことわざへの参加処理
    invitation.add_member!(current_user)

    redirect_to edit_room_proverb_path(room, room.proverb), notice: "部屋に参加しました"

  rescue ActiveSupport::MessageVerifier::InvalidSignature, ActiveRecord::RecordNotFound
    redirect_to root_path, alert: "招待リンクが無効か、有効期限が切れています"
  end
end
