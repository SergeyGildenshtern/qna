require 'rails_helper'

feature 'User can add reward to question', %q{
  In order to provide encouragement for best answer
  As an question's author
  I'd like to be able to add reward
} do

  given(:user) { create(:user) }

  describe 'User adds reward' do
    background do
      login(user)
      visit new_question_path

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

      fill_in 'Reward name', with: 'My reward'
    end

    scenario 'when asks question' do
      attach_file 'Image', "#{Rails.root}/spec/fixtures/files/image.jpg"

      click_on 'Ask'

      within '.reward' do
        expect(page).to have_content 'My reward'
        expect(page).to have_selector 'img'
      end
    end

    scenario 'when asks question with errors ' do
      click_on 'Ask'

      expect(page).to have_content "Reward image can't be blank"
    end
  end
end

