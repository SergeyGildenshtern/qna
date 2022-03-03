require 'rails_helper'

feature 'User can delete answer', "
  In order to delete an answer
  As an authenticated user and as the author of the answer
  I'd like to be able to delete the answer
" do
  given(:question) { create(:question, author: create(:user)) }
  given!(:answer) { create(:answer, question: question, author: create(:user)) }

  describe 'Authenticated user', js: true do
    scenario 'deletes his answer' do
      login(answer.author)
      visit question_path(question)
      click_on 'Delete answer'

      expect(page).to_not have_content answer.body
    end

    scenario 'deletes someone else answer' do
      login(question.author)
      visit question_path(question)

      expect(page).to_not have_button 'Delete answer'
    end
  end

  scenario 'Unauthenticated user tries to delete the answer' do
    visit question_path(question)

    expect(page).to_not have_button 'Delete answer'
  end
end
