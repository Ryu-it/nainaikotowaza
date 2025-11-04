class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :set_unread_notifications_count, if: :user_signed_in?

  before_action :set_unread_invitations_count, if: :user_signed_in?

  def after_sign_in_path_for(resource)
    if session.delete(:oauth_first_login)
      edit_user_registration_path                               # 初回のみユーザー編集ページ
    else
      root_path                                                 # 元いた場所
    end
  end

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
