require 'rails_helper'

RSpec.describe SharesController, type: :controller do
  describe "shares#index action" do
    it "will show the page" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end


  describe "shares#new action" do
    it "will show the new form" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "shares#create action" do
    it "will create a new share in our database" do
      post :create, params: { share: { message: 'Great!' } }
      expect(response).to redirect_to root_path

      share = Share.last
      expect(share.message).to eq("Great!")
    end
    

    it "will deal with validation errors" do
      post :create, params: { share: { message: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(Share.count).to eq 0
    end
  end
end
