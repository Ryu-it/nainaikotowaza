class InvitationsController < ApplicationController
  before_action :authenticate_user!

  def accept
    invitation = Invitation.find_signed(params[:token], purpose: :invite)
    room       = invitation&.room
    return redirect_to messages_path, alert: "招待リンクが無効です。" unless invitation && room

    # 招待先本人か
    return redirect_to messages_path, alert: "招待先ではありません。" unless current_user == invitation.invitee

    # すでにメンバーか？
    already_member = room.room_users.exists?(user_id: current_user.id)

    # 期限切れ or 取り消し
    if invitation.expires_at.past? || invitation.revoked?
      return already_member ?
        redirect_to(edit_room_proverb_path(room, room.proverb), notice: "すでに参加済みのため入室しました。") :
        redirect_to(messages_path, alert: "招待の有効期限が切れています。再招待を依頼してください。")
    end

    # 2回目以降（used_atあり）
    if invitation.used_at.present?
      return already_member ?
        redirect_to(edit_room_proverb_path(room, room.proverb), notice: "この招待は使用済みですが、あなたは参加済みです。") :
        redirect_to(messages_path, alert: "この招待は使用済みです。再招待を依頼してください。")
    end

    # —— 初回受け入れ（ここでidempotentにメンバー化）——
    room.room_users.find_or_create_by!(user: current_user) # 役割があれば role: :proverb_maker 等
    invitation.update!(used_at: Time.current)              # ワンタイム消費

    redirect_to edit_room_proverb_path(room, room.proverb), notice: "招待を受け入れました。"
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    redirect_to messages_path, alert: "招待リンクが無効です。"
  end
end
