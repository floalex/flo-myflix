require 'rails_helper'

describe PasswordResetsController do
  describe "GET show" do
    it "renders the show template if the token is valid" do
      alice = Fabricate(:user)
      alice.update_column(:token, '12345')
      get :show, id: '12345'
      expect(response).to render_template :show
    end
    
    it "redirects to the expired token page if the token is invalid" do
      get :show, id: '12345'
      expect(response).to redirect_to expired_token_path
    end    
  end
  
  describe "POST create" do
    context "with valid token" do
      it "redirects to the sign in page" do
        alice = Fabricate(:user, password: "oldpassword")
        alice.update_column(:token, '12345')
        post :create, token: '12345', password: "newpassword"
        expect(response).to redirect_to sign_in_path
      end
      
      it "updates the user's password" do
        alice = Fabricate(:user, password: "oldpassword")
        alice.update_column(:token, '12345')
        post :create, token: '12345', password: "newpassword"
        expect(alice.reload.authenticate("newpassword")).to be_truthy
      end
      
      it "displays the flash success message" do
        alice = Fabricate(:user, password: "oldpassword")
        alice.update_column(:token, '12345')
        post :create, token: '12345', password: "newpassword"
        expect(flash[:success]).to be_present
      end
      
      it "regenerates a new user token" do
        alice = Fabricate(:user, password: "oldpassword")
        alice.update_column(:token, '12345')
        post :create, token: '12345', password: "newpassword"
        expect(alice.reload.token).not_to eq('12345')
      end
    end
    
    context "with invalid token" do
      it "redirects to the expired token page if the token is invalid" do
        post :create, token: '12345', password: "newpassword"
        expect(response).to redirect_to expired_token_path
      end  
    end
  end
end