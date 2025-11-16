require 'rails_helper'

RSpec.describe "Rooms/Proverbs", type: :system do
  let(:user)    { create(:user) }
  before do
    login_as(user, scope: :user)
  end

  describe "rooms/proverbs投稿ページに特定の文字がある" do
    scenario "この言葉で作ってもらうの文字がある" do
      room = create(:room, :with_members_for, inviter: user)
      expect(room.proverb).to be_present
      visit edit_room_proverb_path(room, room.reload.proverb)
      expect(page).to have_content("この言葉で作ってもらう")
    end

    scenario "招待したユーザーからは招待されたユーザー名が見える" do
      invited = create(:user, name: "tonton") # 招待された側
      room = create(:room, :with_members_for, inviter: user, invitee: invited)
      visit edit_room_proverb_path(room, room.reload.proverb)
      expect(page).to have_content("tonton")
    end

    scenario "招待されたユーザーからは招待したユーザー名が見える" do
      invited = create(:user, name: "tonton") # 招待された側
      room = create(:room, :with_members_for, inviter: user, invitee: invited)
      logout(:user)
      login_as(invited, scope: :user)
      visit edit_room_proverb_path(room, room.reload.proverb)
      expect(page).to have_content(user.name)
    end
  end

  describe "投稿に成功した時(current_user=word_giver)" do
    scenario "遷移先はルームの部屋一覧ページ" do
      room = create(:room, :with_members_for, inviter: user)
      # Proverbが作られているかの確認(status: draft)
      expect(room.proverb).to be_present
      visit edit_room_proverb_path(room, room.reload.proverb)
      fill_in "proverb_word1", with: "猿も"
      fill_in "proverb_word2", with: "木から落ちる"
      click_button "この言葉で作ってもらう"
      expect(page).to have_content("ことわざの言葉を送りました")
      expect(page).to have_current_path(rooms_path, ignore_query: true)
    end

    scenario "ルームの部屋一覧ページに作ったユーザー名がある" do
      room = create(:room, :with_members_for, inviter: user)
      # Proverbが作られているかの確認(status: draft)
      expect(room.proverb).to be_present
      visit edit_room_proverb_path(room, room.reload.proverb)
      fill_in "proverb_word1", with: "猿も"
      fill_in "proverb_word2", with: "木から落ちる"
      click_button "この言葉で作ってもらう"
      expect(page).to have_content(user.name)
    end
  end

  describe "投稿に失敗した時(current_user=word_giver)" do
    scenario "word1が空白の時は失敗する" do
      room = create(:room, :with_members_for, inviter: user)
      expect(room.proverb).to be_present
      visit edit_room_proverb_path(room, room.reload.proverb)
      fill_in "proverb_word1", with: ""
      fill_in "proverb_word2", with: "木から落ちる"
      click_button "この言葉で作ってもらう"
      expect(page).to have_content("更新に失敗しました")
    end

    scenario "word2が空白の時は失敗する" do
      room = create(:room, :with_members_for, inviter: user)
      expect(room.proverb).to be_present
      visit edit_room_proverb_path(room, room.reload.proverb)
      fill_in "proverb_word1", with: "猿も"
      fill_in "proverb_word2", with: ""
      click_button "この言葉で作ってもらう"
      expect(page).to have_content("更新に失敗しました")
    end

    scenario "word1が11文字以上の時は失敗する" do
      room = create(:room, :with_members_for, inviter: user)
      expect(room.proverb).to be_present
      visit edit_room_proverb_path(room, room.reload.proverb)
      fill_in "proverb_word1", with: "a" * 11
      fill_in "proverb_word2", with: "木から落ちる"
      click_button "この言葉で作ってもらう"
      expect(page).to have_content("更新に失敗しました")
    end

    scenario "word2が11文字以上の時は失敗する" do
      room = create(:room, :with_members_for, inviter: user)
      expect(room.proverb).to be_present
      visit edit_room_proverb_path(room, room.reload.proverb)
      fill_in "proverb_word1", with: "猿も"
      fill_in "proverb_word2", with: "a" * 11
      click_button "この言葉で作ってもらう"
      expect(page).to have_content("更新に失敗しました")
    end
  end

  describe "投稿に成功した時(current_user=proverb_maker)" do
    scenario "遷移先はことわざ一覧ページ" do
      invited = create(:user, name: "tonton") # 招待された側
      room = create(:room, :with_members_for, inviter: user, invitee: invited)

      # 1️⃣ word_giver が言葉を送る
      login_as(user, scope: :user)
      visit edit_room_proverb_path(room, room.reload.proverb)
      fill_in "proverb_word1", with: "猿も"
      fill_in "proverb_word2", with: "木から落ちる"
      click_button "この言葉で作ってもらう"
      expect(page).to have_content("ことわざの言葉を送りました")

      # 2️⃣ 一旦ログアウトして、proverb_makerが編集
      logout(:user)
      login_as(invited, scope: :user)

      visit edit_room_proverb_path(room, room.reload.proverb)
      fill_in "proverb_title", with: "猿も木から落ちる"
      fill_in "proverb_meaning", with: "どんなに上手な人でも失敗することがあるという意味"
      fill_in "proverb_example", with: "彼も有名なピアニストだけど、時々ミスをするよ。猿も木から落ちるってことだね。"
      click_button "投稿"
      expect(page).to have_content("ことわざを作成しました")
      expect(page).to have_current_path(proverbs_path, ignore_query: true)
    end
  end

  describe "投稿に失敗した時(current_user=proverb_maker)" do
    scenario "titleが空白の時は失敗する" do
      invited = create(:user, name: "tonton") # 招待された側
      room = create(:room, :with_members_for, inviter: user, invitee: invited)

      # 1️⃣ word_giver が言葉を送る
      login_as(user, scope: :user)
      visit edit_room_proverb_path(room, room.reload.proverb)
      fill_in "proverb_word1", with: "猿も"
      fill_in "proverb_word2", with: "木から落ちる"
      click_button "この言葉で作ってもらう"
      expect(page).to have_content("ことわざの言葉を送りました")

      # 2️⃣ 一旦ログアウトして、proverb_makerが編集
      logout(:user)
      login_as(invited, scope: :user)

      visit edit_room_proverb_path(room, room.reload.proverb)
      fill_in "proverb_title", with: ""
      fill_in "proverb_meaning", with: "どんなに上手な人でも失敗することがあるという意味"
      fill_in "proverb_example", with: "彼も有名なピアニストだけど、時々ミスをするよ。猿も木から落ちるってことだね。"
      click_button "投稿"
      expect(page).to have_content("更新に失敗しました")
    end

    scenario "meaningが空白の時は失敗する" do
      invited = create(:user, name: "tonton") # 招待された側
      room = create(:room, :with_members_for, inviter: user, invitee: invited)

      # 1️⃣ word_giver が言葉を送る
      login_as(user, scope: :user)
      visit edit_room_proverb_path(room, room.reload.proverb)
      fill_in "proverb_word1", with: "猿も"
      fill_in "proverb_word2", with: "木から落ちる"
      click_button "この言葉で作ってもらう"
      expect(page).to have_content("ことわざの言葉を送りました")

      # 2️⃣ 一旦ログアウトして、proverb_makerが編集
      logout(:user)
      login_as(invited, scope: :user)

      visit edit_room_proverb_path(room, room.reload.proverb)
      fill_in "proverb_title", with: "猿も木から落ちる"
      fill_in "proverb_meaning", with: ""
      fill_in "proverb_example", with: "彼も有名なピアニストだけど、時々ミスをするよ。猿も木から落ちるってことだね。"
      click_button "投稿"
      expect(page).to have_content("更新に失敗しました")
    end

    scenario "titleが51文字以上の時は失敗する" do
      invited = create(:user, name: "tonton") # 招待された側
      room = create(:room, :with_members_for, inviter: user, invitee: invited)

      # 1️⃣ word_giver が言葉を送る
      login_as(user, scope: :user)
      visit edit_room_proverb_path(room, room.reload.proverb)
      fill_in "proverb_word1", with: "猿も"
      fill_in "proverb_word2", with: "木から落ちる"
      click_button "この言葉で作ってもらう"
      expect(page).to have_content("ことわざの言葉を送りました")

      # 2️⃣ 一旦ログアウトして、proverb_makerが編集
      logout(:user)
      login_as(invited, scope: :user)

      visit edit_room_proverb_path(room, room.reload.proverb)
      fill_in "proverb_title", with: "a" * 51
      fill_in "proverb_meaning", with: "どんなに上手な人でも失敗することがあるという意味"
      fill_in "proverb_example", with: "彼も有名なピアニストだけど、時々ミスをするよ。猿も木から落ちるってことだね。"
      click_button "投稿"
      expect(page).to have_content("更新に失敗しました")
    end

    scenario "meaningが101文字以上の時は失敗する" do
      invited = create(:user, name: "tonton") # 招待された側
      room = create(:room, :with_members_for, inviter: user, invitee: invited)

      # 1️⃣ word_giver が言葉を送る
      login_as(user, scope: :user)
      visit edit_room_proverb_path(room, room.reload.proverb)
      fill_in "proverb_word1", with: "猿も"
      fill_in "proverb_word2", with: "木から落ちる"
      click_button "この言葉で作ってもらう"
      expect(page).to have_content("ことわざの言葉を送りました")

      # 2️⃣ 一旦ログアウトして、proverb_makerが編集
      logout(:user)
      login_as(invited, scope: :user)

      visit edit_room_proverb_path(room, room.reload.proverb)
      fill_in "proverb_title", with: "猿も木から落ちる"
      fill_in "proverb_meaning", with: "a" * 101
      fill_in "proverb_example", with: "彼も有名なピアニストだけど、時々ミスをするよ。猿も木から落ちるってことだね。"
      click_button "投稿"
      expect(page).to have_content("更新に失敗しました")
    end

    scenario "exampleが301文字以上の時は失敗する" do
      invited = create(:user, name: "tonton") # 招待された側
      room = create(:room, :with_members_for, inviter: user, invitee: invited)

      # 1️⃣ word_giver が言葉を送る
      login_as(user, scope: :user)
      visit edit_room_proverb_path(room, room.reload.proverb)
      fill_in "proverb_word1", with: "猿も"
      fill_in "proverb_word2", with: "木から落ちる"
      click_button "この言葉で作ってもらう"
      expect(page).to have_content("ことわざの言葉を送りました")

      # 2️⃣ 一旦ログアウトして、proverb_makerが編集
      logout(:user)
      login_as(invited, scope: :user)

      visit edit_room_proverb_path(room, room.reload.proverb)
      fill_in "proverb_title", with: "猿も木から落ちる"
      fill_in "proverb_meaning", with: "どんなに上手な人でも失敗することがあるという意味"
      fill_in "proverb_example", with: "a" * 301
      click_button "投稿"
      expect(page).to have_content("更新に失敗しました")
    end
  end
end
