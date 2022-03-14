require 'rails_helper'

feature 'User can delete attached file in question', "
  In order to delete an unnecessary file
  As an authenticated user and as the author of the question
  I'd like to be able to delete attached file
" do

  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question, author: author) }

  background { question.files.attach(create_file_blob) }

  describe 'Authenticated user', js: true do
    scenario 'delete attached file in his question' do
      login(author)
      visit question_path(question)
      click_on 'Delete file'

      expect(page).to_not have_link 'image.jpg'
    end

    scenario 'delete attached file in someone else question' do
      login(user)
      visit question_path(question)

      expect(page).to_not have_button 'Delete file'
    end
  end

  scenario 'Unauthenticated user tries to delete attached file in question' do
    visit question_path(question)

    expect(page).to_not have_button 'Delete file'
  end
end
