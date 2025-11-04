require 'rails_helper'

RSpec.describe "Users", type: :system do
  let(:user) { create(:user) }

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

  describe "マイページを編集した時" do
    it "名前を編集した内容が反映されている" do
      visit new_user_session_path
      fill_in "Eメール", with: user.email
      fill_in "パスワード", with: "12345678"
      click_button "Log in"
      expect(page).to have_content("ログインしました")
      visit edit_user_registration_path
      fill_in "名前", with: "updatedname"
      click_button "更新"
      expect(page).to have_content("アカウント情報を変更しました。")
      expect(page).to have_content("updatedname")
    end

    it "emailを編集した内容が反映されている" do
      visit new_user_session_path
      fill_in "Eメール", with: user.email
      fill_in "パスワード", with: "12345678"
      click_button "Log in"
      expect(page).to have_content("ログインしました")
      visit edit_user_registration_path
      fill_in "Eメール", with: "rantekun@123"
      click_button "更新"
      expect(page).to have_content("アカウント情報を変更しました。")
      logout(:user)
      visit new_user_session_path
      fill_in "Eメール", with: "rantekun@123"
      fill_in "パスワード", with: "12345678"
      click_button "Log in"
      expect(page).to have_content("ログインしました")
    end

    it "パスワードを編集した内容が反映されている" do
      visit new_user_session_path
      fill_in "Eメール", with: user.email
      fill_in "パスワード", with: "12345678"
      click_button "Log in"
      expect(page).to have_content("ログインしました")
      visit edit_user_registration_path
      fill_in "パスワード", with: "newpassword"
      fill_in "パスワード（確認用）", with: "newpassword"
      fill_in "現在のパスワード", with: "12345678"
      click_button "更新"
      expect(page).to have_content("アカウント情報を変更しました。")
      logout(:user)
      visit new_user_session_path
      fill_in "Eメール", with: user.email
      fill_in "パスワード", with: "newpassword"
      click_button "Log in"
      expect(page).to have_content("ログインしました")
    end

    it "アカウントを削除したらログインできない" do
      visit new_user_session_path
      fill_in "Eメール", with: user.email
      fill_in "パスワード", with: "12345678"
      click_button "Log in"
      expect(page).to have_content("ログインしました")
      visit edit_user_registration_path
      accept_confirm do
      click_button "アカウント削除"
      end
      expect(page).to have_content("アカウントを削除しました。")
      visit new_user_session_path
      fill_in "Eメール", with: user.email
      fill_in "パスワード", with: "12345678"
      click_button "Log in"
      expect(page).to have_content("Eメールまたはパスワードが違います。")
    end

    it "編集で現在のパスワードを入力しないと更新できない" do
      visit new_user_session_path
      fill_in "Eメール", with: user.email
      fill_in "パスワード", with: "12345678"
      click_button "Log in"
      expect(page).to have_content("ログインしました")
      visit edit_user_registration_path
      fill_in "パスワード", with: "newpassword"
      fill_in "パスワード（確認用）", with: "newpassword"
      fill_in "現在のパスワード", with: ""
      click_button "更新"
      expect(page).to have_content("現在のパスワードを入力してください")
    end

    it "編集でemailが他のユーザーと同じ時は更新できない" do
      another_user = create(:user, email: "rantekun@123")
      visit new_user_session_path
      fill_in "Eメール", with: user.email
      fill_in "パスワード", with: "12345678"
      click_button "Log in"
      expect(page).to have_content("ログインしました")
      visit edit_user_registration_path
      fill_in "Eメール", with: "rantekun@123"
      click_button "更新"
      expect(page).to have_content("Eメールはすでに存在します")
    end

    it "編集で名前が空欄の時は更新できない" do
      visit new_user_session_path
      fill_in "Eメール", with: user.email
      fill_in "パスワード", with: "12345678"
      click_button "Log in"
      expect(page).to have_content("ログインしました")
      visit edit_user_registration_path
      fill_in "名前", with: ""
      click_button "更新"
      expect(page).to have_content("名前を入力してください")
    end
  end
end
