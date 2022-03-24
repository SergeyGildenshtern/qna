require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:link_url) { 'https://google.ru/' }

  describe 'User adds link' do
    background do
      login(user)
      visit new_question_path

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

      fill_in 'Link name', with: 'My URL'
    end

    scenario 'when asks question' do
      fill_in 'Url', with: link_url

      click_on 'Ask'

      expect(page).to have_link 'My URL', href: link_url
    end

    scenario 'when asks question with errors ' do
      click_on 'Ask'

      expect(page).to have_content "Links url can't be blank"
    end
  end
end
