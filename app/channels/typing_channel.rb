class TypingChannel < ApplicationCable::Channel
  def subscribed
    # 部屋ごとにストリームを分ける
    stream_from "typing_channel_#{params[:room_id]}"
  end

  def receive(data)
    # 受け取った文字を同じ部屋の全員へブロードキャスト
    ActionCable.server.broadcast("typing_channel_#{params[:room_id]}", data)
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
