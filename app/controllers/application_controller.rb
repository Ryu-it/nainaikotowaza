class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :set_unread_notifications_count, if: :user_signed_in?

  before_action :set_unread_invitations_count, if: :user_signed_in?

  def after_sign_in_path_for(resource)
    if session.delete(:oauth_first_login)
      edit_user_registration_path                               # 初回のみユーザー編集ページ
    else
      root_path
    end
  end

  private
  # 招待以外の未読通知数
  def set_unread_notifications_count
    @unread_notifications_count = current_user.passive_notifications
                                              .unread
                                              .excluding_invitations
                                              .count
  end

  # 招待の未読通知数
  def set_unread_invitations_count
    @unread_invitations_count = current_user.passive_notifications
                                            .unread
                                            .invitations
                                            .count
  end
end
