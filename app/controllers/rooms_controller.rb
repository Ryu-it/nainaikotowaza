class RoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :setup_user_search, only: %i[new create]

  def new
    @room = Room.new
  end

  def create
    @room = Room.new(room_attributes)

    user_id = params.dig(:room, :user_id)
    user    = User.find_by(id: user_id)

    unless user
      flash.now[:alert] = "ユーザーを選択してください"
      return render :new, status: :unprocessable_entity
    end

    unless current_user.following?(user)
      redirect_back(
        fallback_location: root_path,
        alert: "フォローしているユーザーのみです"
      )
      return
    end

    @room, @proverb, @invitation =
      Room.create_with_owner_and_invitee!(
        owner:   current_user,
        invitee: user
      )

    redirect_to edit_room_proverb_path(@room, @proverb), notice: "ルームを作成しました"

  rescue ActiveRecord::RecordInvalid
    flash.now[:alert] = "ルームの作成に失敗しました"
    render :new, status: :unprocessable_entity
  end

  def index
    @rooms = current_user.in_progress_proverb_rooms
  end

  private

  def setup_user_search
    past_mode = params[:past_collaborators].present?

    # ベースとなるスコープを決める
    base_scope =
      if past_mode
        current_user.past_collaborators
      else
        current_user.following_users
      end

    # 検索オブジェクト
    @q = base_scope.ransack(params[:q])

    # 実際に表示するユーザー
    @users =
      if params[:q].present?
        @q.result(distinct: true)
      elsif past_mode
        base_scope
      else
        User.none
      end
  end

  def room_attributes
    { owner: current_user }
  end
end
