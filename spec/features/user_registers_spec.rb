# require 'rails_helper'

# # Stripe::InvalidRequestError:
# # Must provide source or customer.

# feature "User register", {js: true, vcr: true} do
#   background do
#     visit register_path
#   end
  
#   scenario "with valid user info and valid card" do
#     fill_in_valid_user_info
#     fill_in_valid_card
#     click_button "Sign Up"
    
#     expect(page).to have_content("Thank you for for registering MyFlix! You can sign in now.")
#   end
  
#   scenario "with valid user info and invalid card" do
#     fill_in_valid_user_info
#     fill_in_invalid_card
#     click_button "Sign Up"
    
#     expect(page).to have_content("The card number is invalid.")
#   end
  
#   scenario "with valid user info and declined card" do
#     fill_in_valid_user_info
#     fill_in_declined_card
#     click_button "Sign Up"
    
#     expect(page).to have_content("The card was declined.")
#   end
  
#   scenario "with invalid user info and valid card" do
#     fill_in_invalid_user_info
#     fill_in_valid_card
#     click_button "Sign Up"
#     expect(page).to have_content("Invalid user information. Please check the errors below.")
#   end
  
#   scenario "with invalid user info and invalid card" do
#     fill_in_invalid_user_info
#     fill_in_invalid_card
#     click_button "Sign Up"
    
#     expect(page).to have_content("The card number is invalid.")
#   end
  
#   scenario "with invalid user info and declined card" do
#     fill_in_invalid_user_info
#     fill_in_declined_card
#     click_button "Sign Up"
    
#     expect(page).to have_content("Invalid user information. Please check the errors below.")
#   end
  
#   def fill_in_valid_user_info
#     fill_in 'Email Address', with: 'joe@example.com'
#     fill_in 'Password', with: '123456'
#     fill_in 'Full Name', with: 'Joe Doe'
#   end
  
#   def fill_in_valid_card
#     fill_in 'Credit Card Number', with: '4242424242424242'
#     fill_in "Security Code", with: "123"
#     select "7 - July", from: "date_month"
#     select "2020", from: "date_year"   
#   end
  
#   def fill_in_invalid_card
#     fill_in 'Credit Card Number', with: '123'
#     fill_in "Security Code", with: "123"
#     select "7 - July", from: "date_month"
#     select "2020", from: "date_year"   
#   end
  
#   def fill_in_declined_card
#     fill_in 'Credit Card Number', with: '4000000000000002'
#     fill_in "Security Code", with: "123"
#     select "7 - July", from: "date_month"
#     select "2020", from: "date_year"
#   end
  
#   def fill_in_invalid_user_info
#     fill_in 'Email Address', with: 'joe@example.com'
#   end
# end