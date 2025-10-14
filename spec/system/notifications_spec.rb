require 'rails_helper'

RSpec.describe "notifications", type: :system do
  let(:actor)     { create(:user) } # フォローする側（通知の actor）
  let(:recipient) { create(:user) } # フォローされる側（通知の recipient）

  let!(:follow)        { create(:follow, follower: actor, followed: recipient) }

  def log_in_as(user)
    visit new_user_session_path
    fill_in "Eメール", with: user.email
    fill_in "パスワード", with: "12345678"
    click_button "Log in"
    expect(page).to have_content("ログインしました")
  end

  describe "通知の確認" do
    scenario "フォロー通知の文言が出る" do
      log_in_as(recipient)
      visit notifications_path
      expect(page).to have_content("「#{actor.name}」さんが あなたをフォローしました")
    end
  end
end
