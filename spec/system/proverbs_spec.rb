require 'rails_helper'

RSpec.describe "Proverbs", type: :system do
  let(:proverb) { create(:proverb) }
  before do
    proverb
    visit new_user_session_path
    fill_in "Eメール", with: "test@gmail.com"
    fill_in "パスワード", with: "12345678"
    click_button "Log in"
    expect(page).to have_content("ログインしました") # まずはここで保証
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
        expect(page).to have_current_path(proverbs_path)
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

  describe "投稿に失敗した時" do
    scenario "遷移先は投稿ページ" do
      visit new_proverb_path
      fill_in "proverb_word1", with: ""
      fill_in "proverb_word2", with: "絵の具"
      fill_in "proverb_title", with: "トンビ"
      fill_in "proverb_meaning", with: "トンビ"
      fill_in "proverb_example", with: "トンビ"
      click_button "投稿"
        expect(page).to have_current_path(new_proverb_path)
    end

    scenario "投稿に失敗した時にフラッシュメッセージが出る" do
      visit new_proverb_path
      fill_in "proverb_word1", with: ""
      fill_in "proverb_word2", with: "絵の具"
      fill_in "proverb_title", with: "トンビ"
      fill_in "proverb_meaning", with: "トンビ"
      fill_in "proverb_example", with: "トンビ"
      click_button "投稿"
        expect(page).to have_content("ことわざの投稿に失敗しました")
    end
  end

  describe "投稿の編集に成功した時" do
    scenario "投稿編集ページに特定の文字がある" do
      visit edit_proverb_path(proverb)
        expect(page).to have_content("ことわざを編集する")
    end

    scenario "遷移先は詳細ページ" do
      visit edit_proverb_path(proverb)
      fill_in "proverb_word1", with: "カラス"
      fill_in "proverb_word2", with: "水"
      fill_in "proverb_title", with: "カラス"
      fill_in "proverb_meaning", with: "カラス"
      fill_in "proverb_example", with: "カラス"
      click_button "編集"
        expect(page).to have_current_path(proverb_path(proverb))
    end

    scenario "編集した時にフラッシュメッセージが出る" do
      visit edit_proverb_path(proverb)
      fill_in "proverb_word1", with: "カラス"
      fill_in "proverb_word2", with: "水"
      fill_in "proverb_title", with: "カラス"
      fill_in "proverb_meaning", with: "カラス"
      fill_in "proverb_example", with: "カラス"
      click_button "編集"
        expect(page).to have_content("ことわざを編集しました")
    end
  end

  describe "投稿の編集に失敗した時" do
    scenario "word1が空白の時は失敗する" do
      visit edit_proverb_path(proverb)
      fill_in "proverb_word1", with: ""
      fill_in "proverb_word2", with: "水"
      fill_in "proverb_title", with: "カラス"
      fill_in "proverb_meaning", with: "カラス"
      fill_in "proverb_example", with: "カラス"
      click_button "編集"
        expect(page).to have_content("ことわざの編集に失敗しました")
    end

    scenario "word2が空白の時は失敗する" do
      visit edit_proverb_path(proverb)
      fill_in "proverb_word1", with: "水"
      fill_in "proverb_word2", with: ""
      fill_in "proverb_title", with: "カラス"
      fill_in "proverb_meaning", with: "カラス"
      fill_in "proverb_example", with: "カラス"
      click_button "編集"
        expect(page).to have_content("ことわざの編集に失敗しました")
    end

    scenario "titleが空白の時は失敗する" do
      visit edit_proverb_path(proverb)
      fill_in "proverb_word1", with: "水"
      fill_in "proverb_word2", with: "水"
      fill_in "proverb_title", with: ""
      fill_in "proverb_meaning", with: "カラス"
      fill_in "proverb_example", with: "カラス"
      click_button "編集"
        expect(page).to have_content("ことわざの編集に失敗しました")
    end

    scenario "meaningが空白の時は失敗する" do
      visit edit_proverb_path(proverb)
      fill_in "proverb_word1", with: "水"
      fill_in "proverb_word2", with: "水"
      fill_in "proverb_title", with: "カラス"
      fill_in "proverb_meaning", with: ""
      fill_in "proverb_example", with: "カラス"
      click_button "編集"
        expect(page).to have_content("ことわざの編集に失敗しました")
    end
  end
end
