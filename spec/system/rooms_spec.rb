require 'rails_helper'

RSpec.describe "Proverbs", type: :system do
  let(:user)    { create(:user) }
  before do
    visit new_user_session_path
    fill_in "Eメール", with: user.email
    fill_in "パスワード", with: "12345678"
    click_button "Log in"
    expect(page).to have_content("ログインしました") # まずはここで保証
  end

  describe "ルーム作成が成功した時" do
    scenario "ルーム作成したら遷移先はroom/proverb#new" do
    other_user = create(:user, name: "tonton")
      user.follow(other_user)
      visit new_room_path
      # formが2つあるので最初のformを指定する
      within(all("form")[0]) do
        fill_in "q_name_cont", with: other_user.name
        find_field("q_name_cont").send_keys(:enter)
      end
      choose "room_user_id_#{other_user.id}"
        within('form[action="/rooms"]', visible: :all) do
          click_button "部屋を作る"
        end
        # 正規表現を使って、/rooms/数字/proverbs/数字/edit というパスであることを確認
        expect(page).to have_current_path(%r{\A/rooms/\d+/proverbs/[0-9a-f-]+/edit\z}, ignore_query: true)
    end

    scenario "ルーム作成に成功した時にフラッシュメッセージが出る", js: true do
      other_user = create(:user, name: "tonton")
      user.follow(other_user)
      visit new_room_path
      # formが2つあるので最初のformを指定する
      within(all("form")[0]) do
        fill_in "q_name_cont", with: other_user.name
        find_field("q_name_cont").send_keys(:enter)
      end
      choose "room_user_id_#{other_user.id}"
        within('form[action="/rooms"]', visible: :all) do
          click_button "部屋を作る"
        end
      expect(page).to have_content("ルームを作成しました")
    end
  end

  describe "ルーム作成が失敗した時" do
    scenario "フォローしていないユーザーを選択した時にエラーメッセージが出る", js: true do
      other_user = create(:user, name: "tonton")
      visit new_room_path
      # formが2つあるので最初のformを指定する
      within(all("form")[0]) do
        fill_in "q_name_cont", with: other_user.name
        find_field("q_name_cont").send_keys(:enter)
      end
      choose "room_user_id_#{other_user.id}"
        within('form[action="/rooms"]', visible: :all) do
          click_button "部屋を作る"
        end
      expect(page).to have_content("フォローしているユーザーのみです")
    end

    scenario "ユーザーを選択せずにルーム作成ボタンを押した時にエラーメッセージが出る", js: true do
      visit new_room_path
        within('form[action="/rooms"]', visible: :all) do
          click_button "部屋を作る"
        end
      expect(page).to have_content("ユーザーを選択してください")
    end
  end
end
