require 'rails_helper'

feature 'User can edit his answer', "
  In order to correct mistakes
  As an author of answer
  I'd like ot be able to edit my answer
" do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, author: user) }
  given!(:other_answer) { create(:answer, question: create(:question), author: create(:user)) }

  describe 'Authenticated user', js: true do
    background do
      login(user)

      visit question_path(question)
    end

    scenario 'edits his answer' do
      click_on 'Edit'

      within '.answers' do
        fill_in 'Your answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answer with errors' do
      click_on 'Edit'

      within '.answers' do
        fill_in 'Your answer', with: ''
        click_on 'Save'
      end

      within '.answer .errors' do
        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario "tries to edit other user's answer" do
      visit question_path(other_answer.question)

      expect(page).to_not have_link 'Edit'
    end
  end

  scenario 'Unauthenticated can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end
end
