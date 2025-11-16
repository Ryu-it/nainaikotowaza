class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :mark_invitations_as_read, only: :index

  def index
    @notifications = current_user.passive_notifications
                                 .invitations
                                 .order(created_at: :desc)
                                 .page(params[:page]).per(10)
  end

  private

  def mark_invitations_as_read
    current_user.passive_notifications
                .invitations
                .unread
                .update_all(is_checked: true)

    # 既読後のカウントにする(ヘッダーのカウント更新のため)
    set_unread_invitations_count
  end
end
