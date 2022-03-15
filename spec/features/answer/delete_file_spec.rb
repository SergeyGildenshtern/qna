require 'rails_helper'

feature 'User can delete attached file in answer', "
  In order to delete an unnecessary file
  As an authenticated user and as the author of the answer
  I'd like to be able to delete attached file
" do
  given(:question) { create(:question, author: create(:user)) }
  given!(:answer) { create(:answer, question: question, author: create(:user)) }

  background { answer.files.attach(create_file_blob) }

  describe 'Authenticated user', js: true do
    scenario 'delete attached file in his answer' do
      login(answer.author)
      visit question_path(question)
      click_on 'Delete file'

      expect(page).to_not have_link 'image.jpg'
    end

    scenario 'delete attached file in someone else answer' do
      login(question.author)
      visit question_path(question)

      expect(page).to_not have_button 'Delete file'
    end
  end

  scenario 'Unauthenticated user tries to delete attached file in answer' do
    visit question_path(question)

    expect(page).to_not have_button 'Delete file'
  end
end
