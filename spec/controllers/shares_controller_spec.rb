require 'rails_helper'

RSpec.describe SharesController, type: :controller do
  describe "shares#destroy action" do
    it "won't allow users who didn't create the share to destroy it" do
      share = FactoryBot.create(:share)
      user = FactoryBot.create(:user)
      sign_in user
      delete :destroy, params: { id: share.id }
      expect(response).to have_http_status(:forbidden)
    end

    it "won't let unauthenticated users destroy a share" do
      share = FactoryBot.create(:share)
      delete :destroy, params: { id: share.id }
      expect(response).to redirect_to new_user_session_path
    end

    it "will allow a user to destroy shares" do
      share = FactoryBot.create(:share)
      sign_in share.user
      delete :destroy, params: { id: share.id }
      expect(response).to redirect_to root_path
      share = Share.find_by_id(share.id)
      expect(share).to eq nil
    end

    it "will return a 404 message if we cannot find a share with the id that is specified" do
      user = FactoryBot.create(:user)
      sign_in user
      delete :destroy, params: { id: 'unavailable' }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "shares#update action" do
    it "won't let users who didn't create the share update it" do
      share = FactoryBot.create(:share)
      user = FactoryBot.create(:user)
      sign_in user
      patch :update, params: { id: share.id, share: { message: 'nice' } }
      expect(response).to have_http_status(:forbidden)
    end

    it "won't let unauthenticated users update a share" do
      share = FactoryBot.create(:share)
      patch :update, params: { id: share.id, share: { message: "Nope" } }
      expect(response).to redirect_to new_user_session_path
    end

    it "will allow users to successfully update shares" do
      share = FactoryBot.create(:share, message: "Start")
      sign_in share.user

      patch :update, params: { id: share.id, share: { message: 'Switched' } }
      expect(response).to redirect_to root_path
      share.reload
      expect(share.message).to eq "Switched"
    end

    it "will have http 404 error if the share cannot be found" do
      user = FactoryBot.create(:user)
      sign_in user

      patch :update, params: { id: "negative", share: { message: 'Changed' } }
      expect(response).to have_http_status(:not_found)
    end

    it "will render the edit form with an http status of unprocessable_entity" do
      share = FactoryBot.create(:share, message: "Start")
      sign_in share.user

      patch :update, params: { id: share.id, share: { message: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
      share.reload
      expect(share.message).to eq "Start"
    end
  end

  describe "shares#edit action" do
    it "won't let a user who did not create the share edit a share" do
      share = FactoryBot.create(:share)
      user = FactoryBot.create(:user)
      sign_in user
      get :edit, params: { id: share.id }
      expect(response).to have_http_status(:forbidden)
    end

    it "won't let unauthenticated users edit a share" do
      share = FactoryBot.create(:share)
      get :edit, params: { id: share.id }
      expect(response).to redirect_to new_user_session_path
    end

    it "will show the edit form if the share is found" do
      share = FactoryBot.create(:share)
      sign_in share.user

      get :edit, params: { id: share.id }
      expect(response).to have_http_status(:success)
    end

    it "will return a 404 error message if the share is not found" do
      user = FactoryBot.create(:user)
      sign_in user

      get :edit, params: { id: 'negative' }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "shares#show action" do
    it "will show the page if the share is found" do
      share = FactoryBot.create(:share)
      get :show, params: { id: share.id }
      expect(response).to have_http_status(:success)
    end

    it "will return a 404 error if the share is not found" do
      get :show, params: { id: 'negative' }
      expect(response).to have_http_status(:not_found)
    end
  end

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
