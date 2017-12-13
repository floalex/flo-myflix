require 'rails_helper'

feature "User signs in" do
  scenario "signing with valid email and password" do
    # put the sign in process to macro to avoid duplication
    alice = Fabricate(:user)
    
    sign_in(alice)
    expect(page).to have_content(alice.full_name)
  end
  
  scenario 'deactivated user tries to sign in' do
    alice = Fabricate(:user, active: false)
    sign_in(alice)
    expect(page).not_to have_content(alice.full_name)
    expect(page).to have_content('Your account has been suspended. Please contact Customer Service.')
  end
end