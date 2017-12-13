require 'rails_helper'

feature 'Admin sees payments' do
  background do
    alice = Fabricate(:user, email: 'alice@example.com', full_name: 'Alice Doe')
    Fabricate(:payment, amount: 999, user: alice)
  end
  
  scenario 'admin can see payments made by users' do
    admin = Fabricate(:admin)
    sign_in(admin)
    visit admin_payments_path
    expect(page).to have_content('$9.99')
    expect(page).to have_content('alice@example.com')
    expect(page).to have_content('Alice Doe')
  end
  
  scenario 'user cannot see payments made by users' do
    joe = Fabricate(:user)
    sign_in(joe)
    visit admin_payments_path
    expect(page).to have_content('You are not authorized to do that')
  end
end