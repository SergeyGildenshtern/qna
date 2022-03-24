require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an question's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:link_url) { 'https://google.ru/' }

  describe 'User adds link', js: true do
    background do
      login(user)

      visit question_path(question)

      fill_in 'Your answer', with: 'My answer'
      fill_in 'Link name', with: 'My URL'
    end

    scenario 'when give an answer' do
      fill_in 'Url', with: link_url

      click_on 'Answer'

      within '.answer' do
        expect(page).to have_link 'My URL', href: link_url
      end
    end

    scenario 'when give an answer with errors ' do
      click_on 'Answer'

      expect(page).to have_content "Links url can't be blank"
    end
  end
end
