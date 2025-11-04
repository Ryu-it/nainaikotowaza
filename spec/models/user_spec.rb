require 'rails_helper'

RSpec.describe User, type: :model do
  describe "バリデーション成功" do
    it "ユーザー登録ができる" do
      user = build(:user)
      expect(user).to be_valid
    end

    it "画像のサイズが10MB以下の時は登録できる" do
      user = build(:user)
      user.avatar.attach(
        io: StringIO.new("a" * (9.megabytes)),
        filename: "small.png",
        content_type: "image/png"
      )
      expect(user).to be_valid
    end

    it "画像の形式がJPEG、PNG、JPGの時は登録できる" do
      %w[jpeg png jpg].each do |format|
        user = build(:user)
        user.avatar.attach(
          io: StringIO.new("test"),
          filename: "test.#{format}",
          content_type: "image/#{format}"
        )
        expect(user).to be_valid
      end
    end
  end

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

    it "確認用パスワードとパスワードが一致しない時はユーザー登録ができない" do
      user = build(:user, password: "password", password_confirmation: "different")
      expect(user).not_to be_valid
    end

    it "画像が10MB以上の時はユーザー登録ができない" do
      user = build(:user)
      user.avatar.attach(
        io: StringIO.new("a" * (11.megabytes)),
        filename: "big.png",
        content_type: "image/png"
      )
      expect(user).not_to be_valid
    end

    it "画像の形式がJPEG、PNG、JPG以外の時はユーザー登録ができない" do
      user = build(:user)
      user.avatar.attach(
        io: StringIO.new("test"),
        filename: "test.gif",
        content_type: "image/gif"
      )
      expect(user).not_to be_valid
    end
  end
end
