require 'rails_helper'

describe ForgotPasswordsController do
  describe "POST create" do
    context "with blank input" do
      it "redirects to the forgot password page" do
        post :create, email: ''
        expect(response).to redirect_to forgot_password_path
      end
      
      it "shows an error message" do
        post :create, email: ''
        expect(flash[:danger]).to eq("Email can't be blank")
      end    
    end
    
    context "with existing email" do
      it "redirects to the forgot password confirmation page" do
        Fabricate(:user, email: "joe@example.com")
        post :create, email: "joe@example.com"
        expect(response).to redirect_to forgot_password_confimration_path
      end
      
      it "sends out the email to the email address" do
        Sidekiq::Testing.inline! do
          Fabricate(:user, email: "joe@example.com")
          post :create, email: "joe@example.com"
          expect(ActionMailer::Base.deliveries.last.to).to eq(['joe@example.com'])
        end
      end
    end
    
    context "with non-existing email" do
      it "redirects to the forgot password page" do
        post :create, email: 'bar@example.com'
        expect(response).to redirect_to forgot_password_path
      end
      
      it "shows an error message" do
        post :create, email: 'bar@example.com'
        expect(flash[:danger]).to eq("Please enter the correct email")
      end    
    end
  end
end