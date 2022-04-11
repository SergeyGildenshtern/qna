require 'rails_helper'

feature 'User can comment the answer', %q{
  In order to comment the answer
  As authenticated user
  I'd like to be able to comment the answer on question's page
} do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  describe 'Authenticated user comment the answer', js: true do
    background do
      login(user)
      visit question_path(question)
    end

    scenario 'with valid data' do
      within '.answer' do
        fill_in 'Text', with: 'Comment text'
        click_on 'Comment'

        expect(page).to have_content 'Comment text'
      end
    end

    scenario 'with invalid data' do
      within '.answer' do
        click_on 'Comment'

        expect(page).to have_content "Text can't be blank"
      end
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
        within '.answer' do
          fill_in 'Text', with: 'Comment text'
          click_on 'Comment'

          expect(page).to have_content 'Comment text'
        end
      end

      Capybara.using_session('guest') do
        within ".answer" do
          expect(page).to have_content 'Comment text'
        end
      end
    end
  end

  scenario 'Unauthenticated user tries to comment the answer' do
    visit questions_path(question)

    expect(page).to_not have_button 'Comment'
  end
end
