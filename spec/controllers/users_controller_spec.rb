require 'rails_helper'

describe UsersController do
  describe "GET new" do
    it "sets @user" do
      # Don't have authentication user case since users controller doesn't have it
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end
  
  describe "POST create" do
    context "with valid input" do
  
      it "creates the user" do
        post :create, user: Fabricate.attributes_for(:user) 
        expect(User.count).to eq(1)
      end
      
      it "redirects to sign in page" do
        post :create, user: Fabricate.attributes_for(:user) 
        expect(response).to redirect_to sign_in_path
      end
      
      it "makes the user follow the inviter" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: 'joe@example.com')
        post :create, user: { email: 'joe@example.com', 
                              password: 'password',
                              full_name: 'Joe Doe'},
                      invitation_token: invitation.token
        joe = User.find_by(email: 'joe@example.com')
        expect(joe.follows?(alice)).to be_truthy
      end
      
      it "makes the inviter follow the user" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: 'joe@example.com')
        post :create, user: { email: 'joe@example.com', 
                              password: 'password',
                              full_name: 'Joe Doe'},
                      invitation_token: invitation.token
        joe = User.find_by(email: 'joe@example.com')
        expect(alice.follows?(joe)).to be_truthy
      end
      
      it "expires the invitation token upon acceptance" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: 'joe@example.com')
        post :create, user: { email: 'joe@example.com', 
                              password: 'password',
                              full_name: 'Joe Doe'},
                      invitation_token: invitation.token
        expect(Invitation.first.token).to be_nil
      end
      
    end
    
    context "with invalid input" do
      before do
        post :create, user: { password: "password", full_name: "Foo Bar" } 
      end
      
      it "does not create the user" do
        expect(User.count).to eq(0)
      end
      
      it "renders the :new template" do
        expect(response).to render_template :new
      end
      
      it "sets @user" do
        expect(assigns(:user)).to be_instance_of(User)
      end
      
    end
    
    context "sending email" do
      after { ActionMailer::Base.deliveries.clear }
      
      it "sends out email to the user with valid inputs" do
        Sidekiq::Testing.inline! do
          post :create, user: { email: "joe@example.com", password: "password", full_name: "Joe Smith" }
          expect(ActionMailer::Base.deliveries.last.to).to eq(['joe@example.com'])
        end
      end
      
      it "sends out email containing the user's name with valid inputs" do
        Sidekiq::Testing.inline! do
          post :create, user: { email: "joe@example.com", password: "password", full_name: "Joe Smith" }
          expect(ActionMailer::Base.deliveries.last.body).to include("Joe Smith")
        end
      end
      
      it "does not send out email to the user with invalid inputs" do
        post :create, user: { email: "joe@example.com" }
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end
  
  describe "GET show" do
    it_behaves_like "requires sign in" do
      let(:action) { get :show, id: 1}
    end
    
    it "sets @user" do
      alice = Fabricate(:user)
      set_current_user(alice)
      get :show, id: alice.id
      expect(assigns(:user)).to eq(alice)
    end
  end
  
  describe "GET new_with_invitation_token" do
    it "renders the :new view template" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(response).to render_template :new
    end
    
    it "sets @user with recipient's email" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:user).email).to eq(invitation.recipient_email)
    end
    
    it "sets @invitation_token" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:invitation_token)).to eq(invitation.token)
    end
    
    it "redirects to expired token page for invalid tokens" do
      get :new_with_invitation_token, token: 'asdrf'
      expect(response).to redirect_to expired_token_path
    end
  end
end