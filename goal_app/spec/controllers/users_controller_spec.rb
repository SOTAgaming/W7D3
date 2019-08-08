require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "GET #new" do
    it "renders the new user page" do
      get :new
      expect(response).to render_template(:new)
      expect(response).to have_http_status(200)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new user" do
        post :create, params: { user: { username: "bob", password: "123456" } }
        expect(User.last).to eq(User.find_by(username: "bob"))
      end

      it "should redirect to user show page" do
        post :create, params: { user: { username: "bob", password: "123456" } }
        expect(response).to redirect_to(user_url(User.last))
      end
    end

    context "with invalid params" do
      it "should raise a 422 error" do
        post :create, params: { user: { username: "", password: "123456" } }
        expect(response).to have_http_status(422)
      end

      it "should render the new user page" do
        post :create, params: { user: { username: "bob", password: "12356" } }
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET #edit" do
    it "renders the edit user page" do
      a = FactoryBot.create(:user)
      get :edit, params: {id: a.id}
      expect(response).to render_template(:edit)
      expect(response).to have_http_status(200)
    end
  end
end
