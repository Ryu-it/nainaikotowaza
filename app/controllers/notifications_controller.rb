class NotificationsController < ApplicationController
  before_action :mark_notifications_as_read, only: :index

  def index
    @notifications = current_user.passive_notifications
                                 .excluding_invitations
                                 .order(created_at: :desc)
                                 .page(params[:page]).per(10)
  end

  private

  def mark_notifications_as_read
    current_user.passive_notifications
                .excluding_invitations
                .unread
                .update_all(is_checked: true)

    # 既読後のカウントにする(ヘッダーのカウント更新のため)
    set_unread_notifications_count
  end
end
