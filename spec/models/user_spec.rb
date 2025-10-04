require 'rails_helper'

RSpec.describe User, type: :model do
  describe "バリデーション成功" do
    it "ユーザー登録ができる" do
      user = build(:user)
      expect(user).to be_valid
    end
  end
end

RSpec.describe User, type: :model do
  describe "バリデーション失敗" do
    it "名前が空白の時はユーザー登録ができない" do
      user = build(:user, name: "")
      expect(user).not_to be_valid
    end

    it "名前が16文字以上の時はユーザー登録ができない" do
      user = build(:user, name: "a" * 16)
      expect(user).not_to be_valid
    end

    it "emailが空白の時はユーザー登録ができない" do
      user = build(:user, email: "")
      expect(user).not_to be_valid
    end

    it "パスワードが7文字以下の時はユーザー登録ができない" do
      user = build(:user, password: "a" * 7, password_confirmation: "a" * 7)
      expect(user).not_to be_valid
    end

    it "確認用パスワードが空白の時はユーザー登録ができない" do
      user = build(:user, password_confirmation: "")
      expect(user).not_to be_valid
    end
  end
end
