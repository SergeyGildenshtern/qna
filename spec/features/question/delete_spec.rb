require 'rails_helper'

feature 'User can delete question', "
  In order to delete a question
  As an authenticated user and as the author of the question
  I'd like to be able to delete the question
" do
  given(:user1) { create(:user) }
  given(:user2) { create(:user) }
  given(:question) { create(:question, author: user1) }

  describe 'Authenticated user' do
    scenario 'deletes his question' do
      login(user1)
      visit question_path(question)
      click_on 'Delete question'

      expect(page).to have_content 'Your question successfully deleted.'
      expect(page).to_not have_content question.title
    end

    scenario 'deletes someone else question' do
      login(user2)
      visit question_path(question)

      expect(page).to_not have_content 'Delete question'
    end
  end

  scenario 'Unauthenticated user tries to delete the question' do
    visit question_path(question)

    expect(page).to_not have_content 'Delete question'
  end
end
