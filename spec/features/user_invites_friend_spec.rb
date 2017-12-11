# require 'rails_helper'

# # Failure/Error: visit sign_in_path
     
# #KeyError:
# # key not found: 100

# feature "User invites friends" do
#   scenario "user successfully invites a friend and the invitation is accepted", { js: true, vcr: true } do
#     alice = Fabricate(:user)
#     sign_in(alice)
  
#     invite_a_friend
#     friend_accepts_invitation(alice)
#     friend_signs_in
   
#     friend_should_follow_inviter(alice)
#     inviter_should_follow_friend(alice)
    
#     # clear_email
#   end
  
#   def invite_a_friend
#     visit new_invitation_path
    
#     fill_in "Friend's Name", with: "John Doe"
#     fill_in "Friend's Email Address", with: "johndoe@example.com"
#     fill_in "Message", with: "Welcome!"
#     click_button "Send Invitation"
    
#     sign_out
#   end
  
#   def friend_accepts_invitation(inviter)
#     # it seems `open_email` can't work on IDE workspace as :letter_opener gem only works on local machine
#     # open_email("johndoe@example.com")
#     # current_email.click_link("Accept this invitation")
    
#     invitation = Fabricate(:invitation, recipient_name: "John Doe", recipient_email: "johndoe@example.com", inviter: inviter)
#     visit register_with_token_url(invitation.token)

#     fill_in "Password", with: "password"
#     fill_in "Full Name", with: "John Doe"
    
#     fill_in "Credit Card Number", with: "4242424242424242"
#     fill_in "Security Code", with: "123"
#     select "7 - July", from: "date_month"
#     select "2020", from: "date_year"
#     click_button "Sign Up"
#   end
  
#   def friend_signs_in
#     fill_in "Email", with: "johndoe@example.com"
#     fill_in "Password", with: "password"
#     click_button "Sign In"
#   end
  
#   def friend_should_follow_inviter(inviter)
#     click_link "People"
#     expect(page).to have_content(inviter.full_name)
#     sign_out
#   end
  
#   def inviter_should_follow_friend(inviter)
#     sign_in(inviter)
    
#     click_link "People"
#     expect(page).to have_content("John Doe")
#   end
# end