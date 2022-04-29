require 'rails_helper'

feature 'User can subscribe to question mailing', %q{
  In order to receive notifications about new answers to question
  As authenticated user
  I'd like to be able subscribe to question mailing
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, author: create(:user)) }

  describe 'Authenticated user', js: true do
    scenario 'subscribe to question mailing' do
      login(user)
      visit question_path(question)
      click_on 'Subscribe to mailing'

      expect(page).to_not have_button 'Subscribe to mailing'
      expect(page).to have_button 'Unsubscribe to mailing'
    end

    scenario 'unsubscribe to question mailing' do
      login(question.author)
      visit question_path(question)
      click_on 'Unsubscribe to mailing'

      expect(page).to_not have_button 'Unsubscribe to mailing'
      expect(page).to have_button 'Subscribe to mailing'
    end
  end

  scenario 'Unauthenticated user tries subscribe to question mailing' do
    visit questions_path(question)

    expect(page).to_not have_button 'Subscribe to mailing'
  end
end
