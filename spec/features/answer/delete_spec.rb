require 'rails_helper'

feature 'User can delete answer', "
  In order to delete an answer
  As an authenticated user and as the author of the answer
  I'd like to be able to delete the answer
" do
  given(:user1) { create(:user) }
  given(:question) { create(:question, author: user1) }

  given(:user2) { create(:user) }
  given!(:answer) { create(:answer, question: question, author: user2) }

  describe 'Authenticated user' do
    scenario 'deletes his answer' do
      login(user2)
      visit question_path(question)
      click_on 'Delete answer'

      expect(page).to have_content 'Your answer successfully deleted.'
    end

    scenario 'deletes someone else answer' do
      login(user1)
      visit question_path(question)

      expect(page).to_not have_content 'Delete answer'
    end
  end

  scenario 'Unauthenticated user tries to delete the answer' do
    visit question_path(question)

    expect(page).to_not have_content 'Delete answer'
  end
end
