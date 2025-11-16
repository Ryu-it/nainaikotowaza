require 'rails_helper'

RSpec.describe "Users", type: :system do
  let(:user) { create(:user) }

  describe "ユーザーページの確認" do
    it "本人にはプロフィール編集ボタンが表示される" do
      login_as(user, scope: :user)
      visit user_path(user)
      expect(page).to have_link "プロフィールを編集"
    end

    it "他人にはプロフィール編集ボタンが表示されない" do
      other_user = create(:user)
      login_as(other_user, scope: :user)
      visit user_path(user)
      expect(page).not_to have_link "プロフィールを編集"
    end
  end

  describe "未登録者の挙動確認" do
    it "未登録ユーザーはマイページに入れない" do
      visit user_path(user)
      expect(page).to have_content("ログインもしくはアカウント登録してください。")
      expect(page).to have_content("新規登録")
    end

    it "未登録ユーザーは編集ページに入れない" do
      visit edit_user_registration_path
      expect(page).to have_content("ログインもしくはアカウント登録してください。")
      expect(page).to have_content("新規登録")
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

    it "失敗したらページにエラーメッセージがある" do
      visit new_user_registration_path
      fill_in "名前", with: ""
      fill_in "Eメール", with: "invalid@email"
      fill_in "パスワード", with: "short"
      fill_in "パスワード（確認用）", with: "mismatch"
      click_button "Sign up"
      expect(page).to have_content("名前を入力してください")
      expect(page).to have_content("パスワードは8文字以上で入力してください")
      expect(page).to have_content("パスワード（確認用）とパスワードの入力が一致しません")
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

    it "間違った情報でログインしたときページにエラーメッセージがある" do
      visit new_user_session_path
      fill_in "Eメール", with: user.email
      fill_in "パスワード", with: "wrongpassword"
      click_button "Log in"
      expect(page).to have_content("Eメールまたはパスワードが違います。")
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

  describe "マイページを編集した時にうまくいく" do
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

    it "成功後の遷移先は詳細ページ" do
      visit new_user_session_path
      fill_in "Eメール", with: user.email
      fill_in "パスワード", with: "12345678"
      click_button "Log in"
      expect(page).to have_content("ログインしました")
      visit edit_user_registration_path
      fill_in "名前", with: "updatedname"
      click_button "更新"
      expect(page).to have_content("アカウント情報を変更しました。")
      expect(current_path).to eq user_path(user)
    end

    it "avatarを編集した内容が反映されている" do
      visit new_user_session_path
      fill_in "Eメール", with: user.email
      fill_in "パスワード", with: "12345678"
      click_button "Log in"
      expect(page).to have_content("ログインしました")
      visit edit_user_registration_path
      attach_file "user_avatar", Rails.root.join("spec/fixtures/test_image.png")
      click_button "更新"
      expect(page).to have_content("アカウント情報を変更しました。")
      expect(page).to have_selector("img[src$='test_image.png']")
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
  end

  describe "マイページを編集した時にうまくいかない" do
    it "名前が空欄の時は更新できない" do
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

    it "名前が空白で、画像があるときも更新できない" do
      visit new_user_session_path
      fill_in "Eメール", with: user.email
      fill_in "パスワード", with: "12345678"
      click_button "Log in"
      expect(page).to have_content("ログインしました")
      visit edit_user_registration_path
      fill_in "名前", with: ""
      attach_file "user_avatar", Rails.root.join("spec/fixtures/test_image.png")
      click_button "更新"
      expect(page).to have_content("名前を入力してください")
    end
  end
end
