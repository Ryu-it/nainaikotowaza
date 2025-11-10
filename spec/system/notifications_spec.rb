require 'rails_helper'

RSpec.describe "notifications", type: :system do
  let(:actor)     { create(:user) } # フォローする側（通知の actor）
  let(:recipient) { create(:user) } # フォローされる側（通知の recipient）

  describe "通知作成の確認" do
    scenario "フォローをするとフォロー通知がある" do
      login_as(recipient, scope: :user)
      follow = create(:follow, follower: actor, followed: recipient)
      visit notifications_path
      # ユーザー名のリンクがあること（hrefまでチェック）
      expect(page).to have_link(actor.name, href: user_path(actor))
      # 残りの文言だけ確認
      expect(page).to have_text("あなたをフォローしました")
    end

    scenario "笑えるリアクションをするとリアクション通知がある" do
      proverb = create(:proverb, owner: recipient)
      login_as(actor, scope: :user)
      visit proverb_path(proverb)
      find("i.fa-face-laugh-squint").click
      expect(page).to have_css("i.fa-face-laugh-squint.text-yellow-500")

      logout(:user)
      login_as(recipient, scope: :user)
      visit notifications_path
      expect(page).to have_link(actor.name, href: user_path(actor))
      expect(page).to have_text("投稿」に「わらえる」をしました")
    end

    scenario "深いリアクションをするとリアクション通知がある" do
      proverb = create(:proverb, owner: recipient)
      login_as(actor, scope: :user)
      visit proverb_path(proverb)
      find("i.fa-lightbulb").click
      expect(page).to have_css("i.fa-lightbulb.text-blue-500")

      logout(:user)
      login_as(recipient, scope: :user)
      visit notifications_path
      expect(page).to have_link(actor.name, href: user_path(actor))
      expect(page).to have_text("投稿」に「深い」をしました")
    end

    scenario "コメントにいいねリアクションをするとリアクション通知がある" do
      proverb = create(:proverb, owner: recipient)
      comment = create(:comment, proverb: proverb, user: recipient)
      login_as(actor, scope: :user)
      visit proverb_path(proverb)
      find("i.fa-heart").click
      expect(page).to have_css("i.fa-heart.text-rose-500")

      logout(:user)
      login_as(recipient, scope: :user)
      visit notifications_path
      expect(page).to have_link(actor.name, href: user_path(actor))
      expect(page).to have_text("コメント」に「いいね」をしました")
    end
  end

  describe "通知削除の確認" do
    scenario "フォローしてフォローを外すと通知が削除される" do
      # 1) actor が recipient をフォロー（UIでもFactoryでもOK）
      login_as(actor, scope: :user)
      visit user_path(recipient)
      click_link "フォローする"
      expect(page).to have_text("フォローを外す")
      logout(:user)

      # 2) recipient で通知が見えること
      login_as(recipient, scope: :user)
      visit notifications_path
      expect(page).to have_link(actor.name, href: user_path(actor))
      expect(page).to have_text("あなたをフォローしました")
      logout(:user)

      # 3) actor に戻ってフォロー解除
      login_as(actor, scope: :user)
      visit user_path(recipient)
      click_link "フォローを外す"
      expect(page).to have_text("フォローする")
      logout(:user)

      # 4) recipient で通知が消えていること
      login_as(recipient, scope: :user)
      visit notifications_path
      expect(page).to have_no_link(actor.name, href: user_path(actor))
      expect(page).to have_no_text("あなたをフォローしました")
    end

    scenario "笑えるリアクションをしてリアクションを外すと通知が削除される" do
      proverb = create(:proverb, owner: recipient)
      login_as(actor, scope: :user)
      visit proverb_path(proverb)
      find("i.fa-face-laugh-squint").click
      expect(page).to have_css("i.fa-face-laugh-squint.text-yellow-500")
      logout(:user)

      login_as(recipient, scope: :user)
      visit notifications_path
      expect(page).to have_text("投稿」に「わらえる」をしました")
      logout(:user)

      login_as(actor, scope: :user)
      visit proverb_path(proverb)
      find("i.fa-face-laugh-squint.text-yellow-500").click
      expect(page).to have_css("i.fa-face-laugh-squint:not(.text-yellow-500)")
      logout(:user)

      login_as(recipient, scope: :user)
      visit notifications_path
      expect(page).to have_no_text("投稿」に「わらえる」をしました")
    end

    scenario "深いリアクションをしてリアクションを外すと通知が削除される" do
      proverb = create(:proverb, owner: recipient)
      login_as(actor, scope: :user)
      visit proverb_path(proverb)
      find("i.fa-lightbulb").click
      expect(page).to have_css("i.fa-lightbulb.text-blue-500")
      logout(:user)

      login_as(recipient, scope: :user)
      visit notifications_path
      expect(page).to have_text("投稿」に「深い」をしました")
      logout(:user)

      login_as(actor, scope: :user)
      visit proverb_path(proverb)
      find("i.fa-lightbulb.text-blue-500").click
      expect(page).to have_css("i.fa-lightbulb:not(.text-blue-500)")
      logout(:user)

      login_as(recipient, scope: :user)
      visit notifications_path
      expect(page).to have_no_text("投稿」に「深い」をしました")
    end

    scenario "コメントにいいねリアクションをしてリアクションを外すと通知が削除される" do
      proverb = create(:proverb, owner: recipient)
      comment = create(:comment, proverb: proverb, user: recipient)
      login_as(actor, scope: :user)
      visit proverb_path(proverb)
      find("i.fa-heart").click
      expect(page).to have_css("i.fa-heart.text-rose-500")
      logout(:user)

      login_as(recipient, scope: :user)
      visit notifications_path
      expect(page).to have_text("コメント」に「いいね」をしました")
      logout(:user)

      login_as(actor, scope: :user)
      visit proverb_path(proverb)
      find("i.fa-heart.text-rose-500").click
      expect(page).to have_css("i.fa-heart:not(.text-rose-500)")
      logout(:user)

      login_as(recipient, scope: :user)
      visit notifications_path
      expect(page).to have_no_text("コメント」に「いいね」をしました")
    end
  end
end
