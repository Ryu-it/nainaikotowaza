require 'rails_helper'

RSpec.describe "Users", type: :system do
    let!(:user) { create(:user) }

  describe "トップページの確認" do
      it "トップページに特定の文字がある" do
        visit root_path
        expect(page).to have_content("NAINAI KOTOWAZA")
      end
    end

    describe "ユーザー登録" do
      it "成功したらページにフラッシュメッセージがある" do
        visit new_user_registration_path
        fill_in "名前", with: "testuser"
        fill_in "Eメール", with: "test@example.com"
        fill_in "パスワード", with: "password"
        fill_in "パスワード（確認用）", with: "password"
        click_button "Sign up"
        expect(page).to have_content("アカウント登録が完了しました。")
      end
    end

    describe "ログインしたとき" do
      it "ページにフラッシュメッセージがある" do
        visit new_user_session_path
        fill_in "Eメール", with: user.email
        fill_in "パスワード", with: "12345678"
        click_button "Log in"
        expect(page).to have_content("ログインしました")
      end
    end

    describe "ログアウトしたとき" do
      it "ページにフラッシュメッセージがある", js: true do
        visit new_user_session_path
        fill_in "Eメール", with: user.email
        fill_in "パスワード", with: "12345678"
        click_button "Log in"
        find(".hamburger-button").click
        click_on "ログアウト"
        expect(page).to have_content("ログアウトしました")
      end
    end

    describe "avatarを登録した時" do
      it "プロフィール編集をした遷移先はusers#show" do
        visit new_user_session_path
        fill_in "Eメール", with: user.email
        fill_in "パスワード", with: "12345678"
        click_button "Log in"
        expect(page).to have_content("ログインしました")
        visit edit_user_registration_path
        attach_file "user_avatar", Rails.root.join("spec/fixtures/test_image.png")
        fill_in "現在のパスワード", with: "12345678"
        click_button "更新"
        expect(page).to have_current_path(user_path(user))
      end

      it "プロフィールページにavatarが表示される" do
        visit new_user_session_path
        fill_in "Eメール", with: user.email
        fill_in "パスワード", with: "12345678"
        click_button "Log in"
        expect(page).to have_content("ログインしました")
        visit edit_user_registration_path
        attach_file "user_avatar", Rails.root.join("spec/fixtures/test_image.png")
        fill_in "現在のパスワード", with: "12345678"
        click_button "更新"
        expect(page).to have_content("アカウント情報を変更しました。")
        expect(page).to have_selector("img[src$='test_image.png']")
      end
    end
  end
