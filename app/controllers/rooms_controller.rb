class RoomsController < ApplicationController
  before_action :authenticate_user!

  def new
    @room = Room.new
    @q = User.ransack(params[:q])
    # 検索をした時だけ表示させる
    @users = params[:q].present? ? @q.result(distinct: true) : User.none
  end

  def create
    # render :new のために必要
    @q = User.ransack(params[:q])
    @users = params[:q].present? ? @q.result(distinct: true) : User.none

    # params から user_name を取り出して User を探す
    user = User.find_by(name: params.dig(:room, :user_name))
    unless user
      flash.now[:alert] = "ユーザーを選択してください"
      return render :new, status: :unprocessable_entity
    end

    # current_user がその user をフォローしているか確認
    unless current_user.following?(user)
      flash.now[:alert] = "フォローしているユーザーのみです"
      return render :new, status: :unprocessable_entity
    end

    # 失敗した時にロールバックするためにトランザクションを使用
    ActiveRecord::Base.transaction do
      @room = Room.new(room_params)
      @room.save!
      # RoomUserを2つ作成する
      @room.room_users.create!(user: current_user, role: :word_giver)

      @proverb = @room.create_proverb!(status: :draft)   # ← 必須項目を要求しない段階で作る
      @proverb.proverb_contributors.create!(user: current_user, role: :word_giver)


      # 招待を作成する
      @invitation = Invitation.create!(
        inviter: current_user,
        invitee: user,
        room: @room,
        expires_at: 3.days.from_now,
        revoked: false
      )

      # 通知を作成する
      @notification = Notification.new(
        actor: current_user,
        recipient: user,
        action: :invitation, notifiable: @invitation
      )
      @notification.save! if @notification.valid?
    end
    redirect_to edit_room_proverb_path(@room, @proverb), notice: "ルームを作成しました"

  rescue ActiveRecord::RecordInvalid
    flash.now[:alert] = "ルームの作成に失敗しました"
    render :new, status: :unprocessable_entity
  end

  def index
    @rooms = current_user.rooms
                         .joins(:proverb)
                         .merge(Proverb.where.not(status: :completed))
                         .includes(:users, :room_users)
                         .order(created_at: :desc)
  end

  private
  def room_params
    params.require(:room).permit(:name).merge(owner: current_user)
  end
end
