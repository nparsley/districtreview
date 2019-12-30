require 'rails_helper'

RSpec.describe SharesController, type: :controller do
  describe "shares#index action" do
    it "will show the page" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end


  describe "shares#new action" do
    it "will require users to be logged in" do
      get :new
      expect(response).to redirect_to new_user_session_path
    end

    it "will show the new form" do
      user = FactoryBot.create(:user)
      sign_in user

      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "shares#create action" do
    it "will require users to be logged in" do
      post :create, params: { share: { message: "Great" } }
      expect(response).to redirect_to new_user_session_path
    end

    it "will create a new share in our database" do
      user = FactoryBot.create(:user)
      sign_in user

      post :create, params: { share: { message: 'Great!' } }
      expect(response).to redirect_to root_path

      share = Share.last
      expect(share.message).to eq("Great!")
      expect(share.user).to eq(user)
    end
    

    it "will deal with validation errors" do
      user = FactoryBot.create(:user)
      sign_in user

      share_count = Share.count
      post :create, params: { share: { message: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(share_count).to eq Share.count
    end
  end
end
