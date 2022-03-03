require 'rails_helper'

feature 'User can edit his question', "
  In order to correct mistakes
  As an author of question
  I'd like ot be able to edit my question
" do

  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given(:other_question) { create(:question, author: create(:user)) }

  describe 'Authenticated user', js: true do
    background do
      login(user)

      visit question_path(question)
    end

    scenario 'edits his question' do
      click_on 'Edit question'
      fill_in 'Question', with: 'edited question'
      click_on 'Save'

      expect(page).to_not have_content question.body
      expect(page).to have_content 'edited question'
      expect(page).to_not have_selector 'input#question_title'
      expect(page).to_not have_selector 'textarea#question_body'
    end

    scenario 'edits his question with errors' do
      click_on 'Edit question'
      fill_in 'Question', with: ''
      click_on 'Save'

      expect(page).to have_content "Body can't be blank"
    end

    scenario "tries to edit other user's question" do
      visit question_path(other_question)

      expect(page).to_not have_link 'Edit question'
    end
  end

  scenario 'Unauthenticated can not edit question' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit question'
  end
end