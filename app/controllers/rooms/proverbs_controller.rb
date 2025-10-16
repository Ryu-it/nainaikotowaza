class Rooms::ProverbsController < ApplicationController
  before_action :authenticate_user!
  def new
    @room = Room.find(params[:room_id])
  end
end
