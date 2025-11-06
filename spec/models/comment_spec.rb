require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe "バリデーション成功" do
    it "コメントを作成できる" do
      comment = build(:comment)
      expect(comment).to be_valid
    end
  end

  describe "バリデーション失敗" do
    it "contentが空白の時はコメントを作成できない" do
      comment = build(:comment, content: "")
      expect(comment).not_to be_valid
    end

    it "contentが301文字以上の時はコメントを作成できない" do
      comment = build(:comment, content: "a" * 301)
      expect(comment).not_to be_valid
    end
  end
end
