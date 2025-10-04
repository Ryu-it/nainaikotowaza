require 'rails_helper'

RSpec.describe User, type: :model do
  describe User do
    context '名前が空白の時はユーザー登録ができない' do
      it "is invalid without a nickname" do
        user = User.new(name: "", email: "aaa@gmail.com", password: "00000000", password_confirmation: "00000000")
        expect(user).not_to be_valid
      end
    end
  end

  describe User do
    context 'emailが空白の時はユーザー登録ができない' do
      it "is invalid without an email" do
        user = User.new(name: "test", email: "", password: "00000000", password_confirmation: "00000000")
        expect(user).not_to be_valid
      end
    end
  end
end
