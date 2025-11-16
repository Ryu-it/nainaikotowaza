require 'rails_helper'

RSpec.describe "Reactions", type: :system do
  let(:user) { create(:user) }

  before do
    login_as(user, scope: :user)
  end

  describe "未登録ユーザーがリアクションをした時" do
    scenario "笑えるアイコンをクリックするとログインページに遷移する" do
      logout(:user)
      proverb = create(:proverb)
      visit proverb_path(proverb)
      find("i.fa-face-laugh-squint").click
      expect(page).to have_content("ログインもしくはアカウント登録してください。")
      expect(page).to have_content("新規登録")
    end

    scenario "深いアイコンをクリックするとログインページに遷移する" do
      logout(:user)
      proverb = create(:proverb)
      visit proverb_path(proverb)
      find("i.fa-lightbulb").click
      expect(page).to have_content("ログインもしくはアカウント登録してください。")
      expect(page).to have_content("新規登録")
    end

    scenario "いいねアイコンをクリックするとログインページに遷移する" do
      logout(:user)
      comment = create(:comment)
      visit proverb_path(comment.proverb)
      find("i.fa-heart").click
      expect(page).to have_content("ログインもしくはアカウント登録してください。")
      expect(page).to have_content("新規登録")
    end
  end

  describe "ことわざへのリアクション" do
    scenario "笑えるアイコンをクリックして作成", js: true do
      visit proverb_path(create(:proverb))
      find("i.fa-face-laugh-squint").click
      expect(page).to have_css("i.fa-face-laugh-squint.text-yellow-500")
      expect(Reaction.last.kind).to eq "laugh"
    end

    scenario "笑えるアイコンをクリックして削除", js: true do
      proverb = create(:proverb)
      create(:reaction, reactable: proverb, user: user, kind: "laugh")
      visit proverb_path(proverb)
      find("i.fa-face-laugh-squint.text-yellow-500").click
      expect(page).to have_css("i.fa-face-laugh-squint:not(.text-yellow-500)")
      expect(Reaction.where(reactable: proverb, user: user, kind: "laugh")).to be_empty
    end

    scenario "深いアイコンをクリックして作成", js: true do
      visit proverb_path(create(:proverb))
      find("i.fa-lightbulb").click
      expect(page).to have_css("i.fa-lightbulb.text-blue-500")
      expect(Reaction.last.kind).to eq "deep"
    end

    scenario "深いアイコンをクリックして削除", js: true do
      proverb = create(:proverb)
      create(:reaction, reactable: proverb, user: user, kind: "deep")
      visit proverb_path(proverb)
      find("i.fa-lightbulb.text-blue-500").click
      expect(page).to have_css("i.fa-lightbulb:not(.text-blue-500)")
      expect(Reaction.where(reactable: proverb, user: user, kind: "deep")).to be_empty
    end
  end

  describe "コメントへのリアクション" do
    scenario "いいねアイコンをクリックして作成", js: true do
      comment = create(:comment)
      visit proverb_path(comment.proverb)
      find("i.fa-heart").click
      expect(page).to have_css("i.fa-heart.text-rose-500")
      expect(Reaction.last.kind).to eq "like"
    end

    scenario "いいねアイコンをクリックして削除", js: true do
      comment = create(:comment)
      create(:reaction, reactable: comment, user: user, kind: "like")
      visit proverb_path(comment.proverb)
      find("i.fa-heart.text-rose-500").click
      expect(page).to have_css("i.fa-heart:not(.text-rose-500)")
      expect(Reaction.where(reactable: comment, user: user, kind: "like")).to be_empty
    end
  end
end
