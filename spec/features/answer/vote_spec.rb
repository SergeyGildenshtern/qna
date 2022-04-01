require 'rails_helper'

feature 'User can vote for answer', %q{
  In order to evaluate the answer
  As an authenticated user
  I'd like to be able vote for answer
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, author: create(:user)) }

  describe 'Authenticated user', js: true do
    context 'not author of answer' do
      background do
        login(user)

        visit question_path(question)
      end

      scenario 'vote up for answer' do
        within '.voting' do
          click_on 'vote up'

          expect(page).to have_content 'Rating: 1'
        end
      end

      scenario 'vote down for answer' do
        within '.voting' do
          click_on 'vote down'

          expect(page).to have_content 'Rating: -1'
        end
      end
    end

    scenario 'author of answer tries to vote for his answer' do
      login(answer.author)

      visit question_path(question)

      within '.voting' do
        expect(page).to_not have_button 'vote up'
        expect(page).to_not have_button 'vote down'
        expect(page).to have_content 'Rating: 0'
      end
    end
  end

  scenario 'Unauthenticated user tries to vote for answer' do
    visit question_path(question)

    within '.voting' do
      expect(page).to_not have_button 'vote up'
      expect(page).to_not have_button 'vote down'
      expect(page).to have_content 'Rating: 0'
    end
  end
end
