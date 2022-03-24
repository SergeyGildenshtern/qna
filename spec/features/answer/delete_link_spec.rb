require 'rails_helper'

feature 'User can delete link in answer', %q{
  In order to delete an unnecessary link
  As an answer's author
  I'd like to be able to delete link
} do
  given(:question) { create(:question, author: create(:user)) }
  given(:answer) { create(:answer, question: question, author: create(:user)) }
  given!(:link) { create(:link, name: 'google', url: 'https://www.google.ru/', linkable: answer) }

  describe 'Authenticated user', js: true do
    scenario 'delete link in his answer' do
      login(answer.author)
      visit question_path(question)
      click_on 'Delete link'

      expect(page).to_not have_link link.name
    end

    scenario 'delete link in someone else answer' do
      login(question.author)
      visit question_path(question)

      expect(page).to_not have_button 'Delete link'
    end
  end

  scenario 'Unauthenticated user tries to delete link in answer' do
    visit question_path(question)

    expect(page).to_not have_button 'Delete link'
  end
end