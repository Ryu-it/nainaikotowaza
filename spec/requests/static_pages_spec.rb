require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  describe "GET /term" do
    it "returns http success" do
      get "/term"
      expect(response).to have_http_status(:success)
    end
  end
end
