require 'rails_helper'

RSpec.describe "follows", type: :system do
  let(:user) { create(:user) }
  before do
    user
    visit new_user_session_path
    fill_in "Eメール", with: user.email
    fill_in "パスワード", with: "12345678"
    click_button "ログイン"
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

  describe "ユーザー詳細のfollowsの変化" do
    scenario "フォローしたら相手のフォロワーが増える", js: true do
      other_user = create(:user)
      visit user_path(other_user)
      click_link "フォローする"
      expect(page).to have_content("フォロワー 1")
    end

    scenario "フォローしたら相手のフォロワーに名前がある", js: true do
      other_user = create(:user)
      visit user_path(other_user)
      click_link "フォローする"
      visit followers_user_path(other_user)
      expect(page).to have_content(user.name)
    end

    scenario "フォローしたら自分のフォロー中が増える", js: true do
      other_user = create(:user)
      visit user_path(other_user)
      click_link "フォローする"
      expect(page).to have_content("フォローを外す")
      visit user_path(user)
      expect(page).to have_content("フォロー中 1")
    end

    scenario "フォローしたら自分のフォロー中に名前がある", js: true do
      other_user = create(:user)
      visit user_path(other_user)
      click_link "フォローする"
      visit following_user_path(user)
      expect(page).to have_content(other_user.name)
    end
  end
end
