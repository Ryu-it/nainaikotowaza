require 'rails_helper'

RSpec.describe "Proverbs", type: :system do
  before do
    user = create(:user)

    visit new_user_session_path
    fill_in "Eメール", with: "test@gmail.com"
    fill_in "パスワード", with: "12345678"
    click_button "Log in"
  end

  describe "投稿ページの確認" do
    scenario "投稿ページに特定の文字がある" do
      visit new_proverb_path
      expect(page).to have_content("ことわざを投稿する")
    end
  end

  describe "投稿に成功した時" do
    scenario "遷移先は一覧" do
      visit new_proverb_path
      fill_in "proverb_word1", with: "トンビ"
      fill_in "proverb_word2", with: "絵の具"
      fill_in "proverb_title", with: "トンビ"
      fill_in "proverb_meaning", with: "トンビ"
      fill_in "proverb_example", with: "トンビ"
      click_button "投稿"
        expect(page).to have_current_path(new_proverb_path)
    end

    scenario "投稿した時にフラッシュメッセージが出る" do
      visit new_proverb_path
      fill_in "proverb_word1", with: "トンビ"
      fill_in "proverb_word2", with: "絵の具"
      fill_in "proverb_title", with: "トンビ"
      fill_in "proverb_meaning", with: "トンビ"
      fill_in "proverb_example", with: "トンビ"
      click_button "投稿"
        expect(page).to have_content("ことわざを投稿しました")
    end
  end
end
