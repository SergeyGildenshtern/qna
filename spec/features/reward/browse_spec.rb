require 'rails_helper'

feature 'User can browse his rewards', "
  In order to view the awards received
  As an authenticated user
  I'd like to be able to browse rewards
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:reward) { create(:reward, question: question, user: user) }

  scenario 'Authenticated user tries to browse questions' do
    login(user)
    click_on 'My rewards'

    within 'table' do
      expect(page).to have_selector 'img'
      expect(page).to have_content reward.name
      expect(page).to have_link question.title
    end
  end

  scenario 'Unauthenticated user tries to browse questions' do
    expect(page).to_not have_link 'My rewards'
  end
end
