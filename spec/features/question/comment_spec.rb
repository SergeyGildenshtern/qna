require 'rails_helper'

feature 'User can comment the question', %q{
  In order to comment the question
  As authenticated user
  I'd like to be able to comment the question
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user comment the question', js: true do
    background do
      login(user)
      visit question_path(question)
    end

    scenario 'with valid data' do
      fill_in 'Text', with: 'Comment text'
      click_on 'Comment'

      expect(page).to have_content 'Comment text'
    end

    scenario 'with invalid data' do
      click_on 'Comment'

      expect(page).to have_content "Text can't be blank"
    end
  end

  context 'Multiple sessions', js: true do
    scenario "comment appears on another user's page" do
      Capybara.using_session('user') do
        login(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'Text', with: 'Comment text'
        click_on 'Comment'

        expect(page).to have_content 'Comment text'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Comment text'
      end
    end
  end

  scenario 'Unauthenticated user tries to comment the question' do
    visit questions_path(question)

    expect(page).to_not have_button 'Comment'
  end
end
