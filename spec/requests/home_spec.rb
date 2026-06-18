require 'rails_helper'

RSpec.describe "Home", type: :request do
  describe "GET /" do
    it "returns http success" do
      get root_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /dashboard" do
    context "when not signed in" do
      it "redirects to sign in" do
        get dashboard_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when signed in as a confirmed user" do
      it "returns http success" do
        user = create(:user)
        sign_in user
        get dashboard_path
        expect(response).to have_http_status(:success)
      end
    end
  end
end
