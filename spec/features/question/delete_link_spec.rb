require 'rails_helper'

feature 'User can delete link in question', %q{
  In order to delete an unnecessary link
  As an question's author
  I'd like to be able to delete link
} do
  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question, author: author) }
  given!(:link) { create(:link, name: 'google', url: 'https://www.google.ru/', linkable: question) }

  describe 'Authenticated user', js: true do
    scenario 'delete link in his question' do
      login(author)
      visit question_path(question)
      click_on 'Delete link'

      expect(page).to_not have_link link.name
    end

    scenario 'delete link in someone else question' do
      login(user)
      visit question_path(question)

      expect(page).to_not have_button 'Delete link'
    end
  end

  scenario 'Unauthenticated user tries to delete link in question' do
    visit question_path(question)

    expect(page).to_not have_button 'Delete link'
  end
end
