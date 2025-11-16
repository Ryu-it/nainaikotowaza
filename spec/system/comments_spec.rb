 require 'rails_helper'

RSpec.describe "Comments", type: :system do
  let(:user)    { create(:user) }
  before do
    login_as(user, scope: :user)
  end

  describe "未登録者がコメントをした時" do
    scenario "未登録ユーザーはコメントが作成できない" do
      logout(:user)
      proverb = create(:proverb)
      visit proverb_path(proverb)
      fill_in "comment_content", with: "素晴らしいことわざですね！"
      click_button "送信"
      expect(page).to have_content("ログインもしくはアカウント登録してください。")
      expect(page).to have_content("新規登録")
    end
  end

  describe "コメント投稿ページの確認" do
    scenario "ことわざ詳細ページに特定の文字がある" do
      proverb = create(:proverb)
      visit proverb_path(proverb)
      expect(page).to have_content("コメント")
    end

    scenario "投稿したユーザーには削除ボタンがある" do
      proverb = create(:proverb)
      comment = create(:comment, user: user, proverb: proverb)
      visit proverb_path(proverb)
      expect(page).to have_css("i.fa-solid.fa-trash")
    end

    scenario "投稿していないユーザーには削除ボタンがない" do
      other_user = create(:user)
      proverb = create(:proverb)
      comment = create(:comment, user: other_user, proverb: proverb)
      visit proverb_path(proverb)
      expect(page).not_to have_css("i.fa-solid.fa-trash")
    end
  end

  describe "コメント投稿に成功した時" do
    scenario "コメント投稿に成功した時フラッシュメッセージが出る" do
      proverb = create(:proverb)
      visit proverb_path(proverb)
      fill_in "comment_content", with: "素晴らしいことわざですね！"
      click_button "送信"
      expect(page).to have_content("コメントが投稿されました。")
    end

    scenario "コメント投稿に成功した時その文字が存在する" do
      proverb = create(:proverb)
      visit proverb_path(proverb)
      fill_in "comment_content", with: "素晴らしいことわざですね！"
      click_button "送信"
      expect(page).to have_content("素晴らしいことわざですね！")
    end
  end

  describe "コメント投稿に失敗した時" do
    scenario "コメント投稿が空白で失敗した時フラッシュメッセージが出る" do
      proverb = create(:proverb)
      visit proverb_path(proverb)
      fill_in "comment_content", with: ""
      click_button "送信"
      expect(page).to have_content("コメントの投稿に失敗しました。")
    end

    scenario "コメント投稿が301文字以上で失敗した時フラッシュメッセージが出る" do
      proverb = create(:proverb)
      visit proverb_path(proverb)
      fill_in "comment_content", with: "a" * 301
      click_button "送信"
      expect(page).to have_content("コメントの投稿に失敗しました。")
    end
  end

  describe "コメント投稿の削除に成功した時" do
    scenario "コメント投稿の削除に成功した時フラッシュメッセージが出る" do
      proverb = create(:proverb)
      comment = create(:comment, user: user, proverb: proverb)
      visit proverb_path(proverb)
      accept_confirm do
      find("i.fa-solid.fa-trash").click
      end
      expect(page).to have_content("コメントを削除しました。")
    end

    scenario "コメント投稿の削除に成功した時その文字が存在しない" do
      proverb = create(:proverb)
      comment = create(:comment, content: "素晴らしいことわざですね！", user: user, proverb: proverb)
      visit proverb_path(proverb)
      accept_confirm do
      find("i.fa-solid.fa-trash").click
      end
      expect(page).not_to have_content("素晴らしいことわざですね！")
    end
  end
end
