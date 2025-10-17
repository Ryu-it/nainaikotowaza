class MessagesController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.passive_notifications
                                 .order(created_at: :desc)
  end
end
