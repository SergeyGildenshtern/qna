require 'rails_helper'

feature 'User can sign out', "
  In order to change the account
  As an authenticated user
  I'd like to be able to sign out
" do
  given(:user) { create(:user) }

  background { visit root_path }

  scenario 'Registered user tries to sign out' do
    login(user)
    click_on 'Sign out'

    expect(page).to have_content 'Signed out successfully.'
  end

  scenario 'Unregistered user tries to sign out' do
    expect(page).to_not have_content 'Sign out'
  end
end
