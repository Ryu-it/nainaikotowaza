require 'rails_helper'

RSpec.describe Room, type: :model do
  describe "部屋を作成できる" do
    it "値が全て存在すれば登録できる" do
      room = build(:room)
      expect(room).to be_valid
    end
  end

  describe "部屋を作成できない" do
    it "owner_idが空白の時は登録できない" do
      room = build(:room, owner_id: "")
      expect(room).not_to be_valid
    end
  end
end
