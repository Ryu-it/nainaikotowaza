require 'rails_helper'

RSpec.describe "Proverbs", type: :system do
  let(:user)    { create(:user) }
  let(:proverb) { create(:proverb, owner: user) }
  before do
    login_as(user, scope: :user)
  end

  describe "投稿ページの確認" do
    scenario "投稿ページに特定の文字がある" do
      visit new_proverb_path
      expect(page).to have_content("ことわざを投稿する")
    end

    scenario "ログインしていないユーザーでも一覧には入れる" do
      logout(:user)
      visit proverbs_path
      expect(page).to have_button("検索")
    end

    scenario "ログインしていないユーザーでも詳細には入れる" do
      logout(:user)
      proverb = create(:proverb)
      visit proverb_path(proverb)
      expect(page).to have_content(proverb.title)
    end

    scenario "ログインしていないユーザーは作成ページに入れない" do
      logout(:user)
      visit new_proverb_path
      expect(page).to have_content("ログインもしくはアカウント登録してください。")
      expect(page).to have_content("新規登録")
    end

    scenario "ログインしていないユーザーは編集ページに入れない" do
      logout(:user)
      visit edit_proverb_path(proverb)
      expect(page).to have_content("ログインもしくはアカウント登録してください。")
      expect(page).to have_content("新規登録")
    end

    scenario "作成したユーザー以外は編集ボタンがない" do
      other_user    = create(:user)
      other_proverb = create(:proverb, owner: other_user)
      visit proverb_path(other_proverb)
      expect(page).not_to have_css("i.fa-pen-to-square")
    end

    scenario "作成したユーザーには編集ボタンがある" do
      visit proverb_path(proverb)
      expect(page).to have_css("i.fa-pen-to-square")
    end

    scenario "作成したユーザー以外は削除ボタンがない" do
      other_user = create(:user)
      other_proverb = create(:proverb, owner: other_user)
      visit proverb_path(other_proverb)
      expect(page).not_to have_css("i.fa-trash")
    end

    scenario "作成したユーザーには削除ボタンがある" do
      visit proverb_path(proverb)
      expect(page).to have_css("i.fa-trash")
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

    scenario "投稿した内容が一覧に存在する" do
      visit new_proverb_path
      fill_in "proverb_word1", with: "トンビ"
      fill_in "proverb_word2", with: "絵の具"
      fill_in "proverb_title", with: "トンビ"
      fill_in "proverb_meaning", with: "トンビ"
      fill_in "proverb_example", with: "トンビ"
      click_button "投稿"
        expect(page).to have_content("トンビ")
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

    scenario "編集した内容が詳細ページに存在する" do
      visit edit_proverb_path(proverb)
      fill_in "proverb_word1", with: "カラス"
      fill_in "proverb_word2", with: "水"
      fill_in "proverb_title", with: "カラス"
      fill_in "proverb_meaning", with: "カラス"
      fill_in "proverb_example", with: "カラス"
      click_button "編集"
        expect(page).to have_content("カラス")
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

  describe "投稿の削除に成功した時" do
    scenario "遷移先は一覧ページ" do
      visit proverb_path(proverb)
      accept_confirm do
      find("i.fa-solid.fa-trash").click
      end
      expect(page).to have_current_path(proverbs_path)
    end

    scenario "削除した時にフラッシュメッセージが出る" do
      visit proverb_path(proverb)
      accept_confirm do
      find("i.fa-solid.fa-trash").click
      end
      expect(page).to have_content("ことわざを削除しました")
    end

    scenario "削除した内容が一覧ページに存在しない" do
      visit proverb_path(proverb)
      accept_confirm do
      find("i.fa-solid.fa-trash").click
      end
      expect(page).not_to have_content(proverb.title)
    end
  end
end
