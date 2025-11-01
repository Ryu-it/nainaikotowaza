class HealthController < ActionController::API
  def show
    render json: { ok: true, ts: Time.now.to_i }
  end
end
