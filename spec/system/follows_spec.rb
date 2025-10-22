require 'rails_helper'

RSpec.describe "follows", type: :system do
  let(:user) { create(:user) }
  before do
    user
    visit new_user_session_path
    fill_in "Eメール", with: user.email
    fill_in "パスワード", with: "12345678"
    click_button "Log in"
    expect(page).to have_content("ログインしました") # まずはここで保証
  end

  describe "フォローが成功した時" do
    scenario "レコードが作成される" do
      other_user = create(:user)
      visit users_path
      within("form") do
        fill_in "q_name_cont", with: other_user.name
        find_field("q_name_cont").send_keys(:enter)
      end
      click_link "フォロー"
      expect(page).to have_content("フォローを外す")
      expect(user.following?(other_user)).to be_truthy
    end

    scenario "フォローした遷移先はその場" do
      other_user = create(:user)
      visit users_path
      within("form") do
        fill_in "q_name_cont", with: other_user.name
        find_field("q_name_cont").send_keys(:enter)
      end
      click_link "フォロー"
      expect(page).to have_current_path(users_path, ignore_query: true)
    end

    scenario "フォローした時にフラッシュメッセージが出る", js: true do
      other_user = create(:user)
      visit users_path
      within("form") do
        fill_in "q_name_cont", with: other_user.name
        find_field("q_name_cont").send_keys(:enter)
      end
      click_link "フォロー"
      expect(page).to have_content("フォローを外す")
    end
  end

  describe "フォロー解除の確認" do
    scenario "フォロー解除した遷移先はその場", js: true do
      other_user = create(:user)
      user.follow(other_user) # 事前にフォローしておく
      visit users_path
      within("form") do
        fill_in "q_name_cont", with: other_user.name
        find_field("q_name_cont").send_keys(:enter)
      end
      click_link "フォローを外す"
      expect(page).to have_current_path(users_path, ignore_query: true)
    end

    scenario "フォロー解除した時にフラッシュメッセージが出る", js: true do
      other_user = create(:user)
      user.follow(other_user) # 事前にフォローしておく
      visit users_path
      within("form") do
        fill_in "q_name_cont", with: other_user.name
        find_field("q_name_cont").send_keys(:enter)
      end
      click_link "フォローを外す"
      expect(page).to have_content("フォローする")
    end
  end
end
