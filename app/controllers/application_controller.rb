class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :set_unread_notifications_count, if: :user_signed_in?

  before_action :set_unread_invitations_count, if: :user_signed_in?

  private
  # notificationsテーブルのfalseレコードを取得してカウント(Invitaionは除く)
  def set_unread_notifications_count
    @unread_notifications_count = current_user.passive_notifications.unread.where.not(notifiable_type: "Invitation").count
  end

  # notificationsテーブルのnotifiable=invitaionのfalseレコードを取得してカウント
  def set_unread_invitations_count
    @unread_invitations_count = current_user.passive_notifications.unread.where(notifiable_type: "Invitation").count
  end
end
