require 'rails_helper'

RSpec.describe "Managers", type: :request do
  describe "GET /dashboard" do
    it "returns http success" do
      get "/managers/dashboard"
      expect(response).to have_http_status(:success)
    end
  end

end
