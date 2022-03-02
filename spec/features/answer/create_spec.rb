require 'rails_helper'

feature 'User can create answer', "
  In order to answer the question
  As an authenticated user
  I'd like to be able to create an answer the question
" do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    background do
      login(user)

      visit question_path(question)
    end

    scenario 'answer the question' do
      fill_in 'Your answer', with: 'Test answer'
      click_on 'Answer'

      expect(current_path).to eq question_path(question)
      within '.answers' do
        expect(page).to have_content 'Test answer'
      end
    end

    scenario 'answer the question with errors' do
      click_on 'Answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to answer the question', js: true do
    visit question_path(question)
    click_on 'Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
