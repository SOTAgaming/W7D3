require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe "GET #new" do
    it "should generate login page" do 
      get :new
      expect(response).to have_http_status(200)
      expect(response).to render_template(:new)
    end
  end

  describe "POST #create" do

    it "should login with correct credentials" do
      user = FactoryBot.create(:user)
      post :create, params: { session: { username: user.username, password: "123456" } }
      expect(response).to redirect_to(user_url(user))
      expect(response).to have_http_status(302)
    end

  end

  describe "DELETE #destroy" do
    it "should logout the user" do
      user = FactoryBot.create(:user)
      post :create, params: { session: { username: user.username, password: "123456" } }
      delete :destroy
      
      expect(response).to redirect_to(new_sessions_url)
      expect(session[:session_token]).to be(nil)

    end
  end
end
