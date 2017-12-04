require 'rails_helper'

feature "User resets password" do
  scenario "user succesfully resets the password" do
    Sidekiq::Testing.inline! do
      alice = Fabricate(:user, password: "old_password")
      visit sign_in_path
      click_link "Forgot Password?"
      fill_in "Email Address", with: alice.email
      click_button "Send Email"
      
      # it seems `open_email` can't work on IDE workspace as :letter_opener gem only works on local machine
      # open_email(alice.email)
      # current_email.click_link("Reset My Password")
      
      visit password_reset_url(alice.token)
      
      fill_in "New Password", with: "new_password"
      click_button "Reset Password"
      
      fill_in "Email Address", with: alice.email
      fill_in "Password", with: "new_password"
      click_button "Sign In"
      expect(page).to have_content("Welcome, #{alice.full_name}")
      
      # clear_email
    end
  end
end