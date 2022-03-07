require 'rails_helper'

feature 'User can choice best answer', "
  In order to highlight the best solution
  As an author of question
  I'd like to be able to choice best answer
" do
  given(:question) { create(:question, author: create(:user)) }
  given!(:answer) { create(:answer, question: question, author: create(:user)) }
  given!(:other_answer) { create(:answer, question: question) }

  describe 'Authenticated user', js: true do
    context 'author of question' do
      background do
        login(question.author)
        visit question_path(question)

        within ".answer[data-answer-id='#{answer.id}']" do
          click_on 'Best answer'
        end
      end

      scenario 'choice best answer' do
        within '.best-answer' do
          expect(page).to have_content answer.body
          expect(page).to_not have_button 'Best answer'
        end
      end

      scenario 're-choice best answer' do
        within ".answer[data-answer-id='#{other_answer.id}']" do
          click_on 'Best answer'
        end

        within '.best-answer' do
          expect(page).to have_content other_answer.body
          expect(page).to_not have_button 'Best answer'
        end

        within ".answer[data-answer-id='#{answer.id}']" do
          expect(page).to have_button 'Best answer'
        end
      end
    end

    scenario 'Not author of question tries to choose best answer' do
      login(answer.author)
      visit question_path(question)

      expect(page).to_not have_button 'Best answer'
    end
  end

  scenario 'Unauthenticated user tries to choice best answer' do
    visit question_path(question)

    expect(page).to_not have_button 'Best answer'
  end
end
