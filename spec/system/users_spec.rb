require 'rails_helper'

RSpec.describe "Users", type: :system do
  describe "ユーザー登録" do
      it "特定のページに特定の文字がある" do
        visit root_path
        expect(page).to have_content("ないないことわざ")
      end
    end
  end
