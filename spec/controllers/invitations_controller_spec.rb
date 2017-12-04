require 'rails_helper'

describe InvitationsController do
  describe "GET new" do
    it "sets @invitation to a new invitation" do
      set_current_user
      get :new
      expect(assigns(:invitation)).to be_new_record
      expect(assigns(:invitation)).to be_instance_of Invitation
    end
    
    it_behaves_like "requires sign in" do
      let(:action) { get :new }
    end
  end
  
  describe "POST crteate" do
    it_behaves_like "requires sign in" do
      let(:action) { post :create }
    end
    
    context "with valid inputs" do
      after { ActionMailer::Base.deliveries.clear }
      
      it "redirects to the new invitation page" do
        set_current_user
        post :create, invitation: { recipient_name: "Joe Smith", recipient_email: "joesmith@example.com",
                                    message: "Join MyFlix" }
        expect(response).to redirect_to new_invitation_path
      end
      
      it "creates an invitation" do
        Sidekiq::Testing.inline! do
          set_current_user

          post :create, invitation: { recipient_name: "Joe Smith", recipient_email: "joesmith@example.com",
                                      message: "Join MyFlix" }
          expect(Invitation.count).to eq(1)
        end
      end
      
      it "sends out an email to the recipient" do
        Sidekiq::Testing.inline! do
          set_current_user
          post :create, invitation: { recipient_name: "Joe Smith", recipient_email: "joesmith@example.com",
                                      message: "Join MyFlix" }
          expect(ActionMailer::Base.deliveries.last.to).to eq(["joesmith@example.com"])
        end
      end
      
      it "sets the flash success message" do
        set_current_user
        post :create, invitation: { recipient_name: "Joe Smith", recipient_email: "joesmith@example.com",
                                    message: "Join MyFlix" }
        expect(flash[:success]).to be_present
      end
    end
    
    context "with invalid inputs" do
      it "renders the new template" do
        set_current_user
        post :create, invitation: { recipient_email: "joesmith@example.com",
                                    message: "Join MyFlix" }
        expect(response).to render_template :new
      end
      
      it "does not create the invitation" do
        set_current_user
        post :create, invitation: { recipient_email: "joesmith@example.com",
                                    message: "Join MyFlix" }
        expect(Invitation.count).to eq(0)
      end
      
      it "does not send out the email to the recipient" do
        set_current_user
        post :create, invitation: { recipient_email: "joesmith@example.com",
                                    message: "Join MyFlix" }
        expect(ActionMailer::Base.deliveries).to be_empty
      end
      
      it "sets the flash danger message" do
        set_current_user
        post :create, invitation: { recipient_email: "joesmith@example.com",
                                    message: "Join MyFlix" }
        expect(flash[:danger]).to be_present
      end
      
      it "sets @invitation" do
        set_current_user
        post :create, invitation: { recipient_email: "joesmith@example.com",
                                    message: "Join MyFlix" }
        expect(assigns(:invitation)).to be_present
      end
      
    end
  end
end