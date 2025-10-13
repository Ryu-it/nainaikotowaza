require 'rails_helper'

RSpec.describe Follow, type: :model do
  describe "フォローが成功する" do
    let(:user) { create(:user, :with_active_follows) }
    it "フォローできること" do
      expect(user.active_follows.count).to eq(1)
    end
  end

  describe "フォローが失敗する" do
    let(:user) { create(:user) }
    it "自分自身をフォローできないこと" do
      follow = build(:follow, follower: user, followed: user)
      expect(follow).not_to be_valid
    end

    it "同じユーザーを重複してフォローできないこと" do
      other_user = create(:user)
      create(:follow, follower: user, followed: other_user)
      duplicate_follow = build(:follow, follower: user, followed: other_user)
      expect(duplicate_follow).not_to be_valid
    end
  end

  describe "フォローが削除できる" do
    let(:user) { create(:user, :with_active_follows) }
    it "フォローを削除できること" do
      follow = user.active_follows.first
      expect { follow.destroy }.to change { Follow.count }.by(-1)
    end
  end
end
