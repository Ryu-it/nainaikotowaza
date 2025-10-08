require 'rails_helper'

RSpec.describe Proverb, type: :model do
  describe "バリデーション成功" do
    it "ことわざを作成できる" do
      proverb = build(:proverb)
      expect(proverb).to be_valid
    end
  end

  describe "バリデーション失敗" do
    it "word1が空白の時はことわざを作成できない" do
      proverb = build(:proverb, word1: "")
      expect(proverb).not_to be_valid
    end

    it "word2が空白の時はことわざを作成できない" do
      proverb = build(:proverb, word2: "")
      expect(proverb).not_to be_valid
    end

    it "titleが空白の時はことわざを作成できない" do
      proverb = build(:proverb, title: "")
      expect(proverb).not_to be_valid
    end

    it "meaningが空白の時はことわざを作成できない" do
      proverb = build(:proverb, meaning: "")
      expect(proverb).not_to be_valid
    end

    it "word1が11文字以上の時はことわざを作成できない" do
      proverb = build(:proverb, word1: "a" * 11)
      expect(proverb).not_to be_valid
    end

    it "word2が11文字以上の時はことわざを作成できない" do
      proverb = build(:proverb, word2: "a" * 11)
      expect(proverb).not_to be_valid
    end

    it "titleが51文字以上の時はことわざを作成できない" do
      proverb = build(:proverb, title: "a" * 51)
      expect(proverb).not_to be_valid
    end

    it "meaningが101文字以上の時はことわざを作成できない" do
      proverb = build(:proverb, meaning: "a" * 101)
      expect(proverb).not_to be_valid
    end

    it "exampleが301文字以上の時はことわざを作成できない" do
      proverb = build(:proverb, example: "a" * 301)
      expect(proverb).not_to be_valid
    end
  end
end
