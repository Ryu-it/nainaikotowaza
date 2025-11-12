class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.passive_notifications
                                 .excluding_invitations
                                 .order(created_at: :desc)
                                 .page(params[:page]).per(10)
  end
end
