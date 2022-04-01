require 'rails_helper'

feature 'User can vote for question', %q{
  In order to evaluate the question
  As an authenticated user
  I'd like to be able vote for question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, author: create(:user)) }

  describe 'Authenticated user', js: true do
    context 'not author of question' do
      background do
        login(user)

        visit questions_path
      end

      scenario 'vote up for question' do
        within '.voting' do
          click_on 'vote up'

          expect(page).to have_content 'Rating: 1'
        end
      end

      scenario 'vote down for question' do
        within '.voting' do
          click_on 'vote down'

          expect(page).to have_content 'Rating: -1'
        end
      end
    end

    scenario 'author of question tries to vote for his question' do
      login(question.author)

      visit questions_path

      within '.voting' do
        expect(page).to_not have_button 'vote up'
        expect(page).to_not have_button 'vote down'
        expect(page).to have_content 'Rating: 0'
      end
    end
  end

  scenario 'Unauthenticated user tries to vote for question' do
    visit questions_path

    within '.voting' do
      expect(page).to_not have_button 'vote up'
      expect(page).to_not have_button 'vote down'
      expect(page).to have_content 'Rating: 0'
    end
  end
end
