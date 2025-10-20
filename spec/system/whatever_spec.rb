require 'rails_helper'

RSpec.describe "ログイン・ログアウトの確認", type: :system do
  let(:user)   { create(:user) }

  it "login_asとlogoutでログイン状態が切り替わる" do
    # 1️⃣ ログイン
    login_as(user, scope: :user)
    visit root_path

    # ログイン後は「ログアウト」リンクが表示される
    expect(page).to have_content("ログアウト"), "ログイン後に 'ログアウト' が見つかりません"

    # 2️⃣ ログアウト
    logout(:user)
    visit root_path

    # ログアウト後は「ログアウト」リンクが消える
    expect(page).not_to have_content("ログアウト"), "ログアウト後も 'ログアウト' が表示されています"

    other_user = create(:user)
    login_as(other_user, scope: :user)
    visit root_path
    # ログイン後は「ログアウト」リンクが表示される
    expect(page).to have_content("ログアウト"), "ログイン後に 'ログアウト' が見つかりません"
  end
end
