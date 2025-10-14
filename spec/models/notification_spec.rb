require 'rails_helper'

RSpec.describe Notification, type: :model do
  describe "通知が作成される" do
    let(:follow) { create(:follow) }
    it "フォローしたときに通知が作成される" do
      expect(follow.followed.passive_notifications.count).to eq(1)
    end
  end
end
