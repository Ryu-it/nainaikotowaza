require 'rails_helper'

RSpec.describe Reaction, type: :model do
  describe "ことわざにリアクションができる" do
    it "ことわざに笑えるのリアクションができる" do
      reaction = create(:reaction, :laugh)
      expect(reaction.reactable).to be_a(Proverb)
      expect(reaction.kind).to eq("laugh")
    end

    it "ことわざに深いのリアクションができる" do
      reaction = create(:reaction, :deep)
      expect(reaction.reactable).to be_a(Proverb)
      expect(reaction.kind).to eq("deep")
    end
  end

  describe "コメントにリアクションができる" do
    it "コメントにいいねのリアクションができる" do
      reaction = create(:reaction, :for_comment)
      expect(reaction.reactable).to be_a(Comment)
      expect(reaction.kind).to eq("like")
    end
  end
end
