require 'rails_helper'

RSpec.describe "Rooms/Proverbs", type: :system do
  let(:user)    { create(:user) }
  before do
    visit new_user_session_path
    fill_in "Eメール", with: user.email
    fill_in "パスワード", with: "12345678"
    click_button "Log in"
    expect(page).to have_content("ログインしました") # まずはここで保証
  end

  describe "投稿ページの確認" do
    scenario "rooms/proverbs投稿ページに特定の文字がある" do
      room = create(:room, :with_members_for, current_user: user)
      expect(room.proverb).to be_present
      visit edit_room_proverb_path(room, room.reload.proverb)
      expect(page).to have_content("この言葉で作ってもらう")
    end
  end

  describe "投稿に成功した時" do
    scenario "遷移先はルームのことわざの編集ページ" do
      room = create(:room, :with_members_for, current_user: user)
      # Proverbが作られているかの確認(status: draft)
      expect(room.proverb).to be_present
      visit edit_room_proverb_path(room, room.reload.proverb)
      fill_in "proverb_word1", with: "猿も"
      fill_in "proverb_word2", with: "木から落ちる"
      click_button "この言葉で作ってもらう"
      expect(page).to have_content("ことわざの言葉を送りました")
    end
  end
end
