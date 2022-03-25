require 'rails_helper'

feature 'User can edit his question', "
  In order to correct mistakes
  As an author of question
  I'd like ot be able to edit my question
" do

  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }
  given(:other_question) { create(:question, author: create(:user)) }
  given!(:link) { create(:link, linkable: question) }
  given(:new_url) { 'https://yandex.ru/' }

  describe 'Authenticated user', js: true do
    background do
      question.files.attach(create_file_blob)
      login(user)

      visit question_path(question)
    end

    scenario 'edits his question' do
      click_on 'Edit question'
      fill_in 'Question', with: 'edited question'
      click_on 'Save'

      expect(page).to_not have_content question.body
      expect(page).to have_content 'edited question'
      expect(page).to_not have_selector 'input#question_title'
      expect(page).to_not have_selector 'textarea#question_body'
    end

    scenario 'edits his question with new attached file' do
      click_on 'Edit question'
      within '#edit-question' do
        attach_file 'File', %W[#{Rails.root}/spec/rails_helper.rb #{Rails.root}/spec/spec_helper.rb]
        click_on 'Save'
      end

      within '.question-files' do
        expect(page).to have_link 'image.jpg'
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'edits his answer with new link' do
      click_on 'Edit question'

      within '#edit-question' do
        click_on 'add link'

        within all('.nested-fields').last do
          fill_in 'Link name', with: 'yandex'
          fill_in 'Url', with: new_url
        end

        click_on 'Save'
      end

      expect(page).to have_link 'google', href: link.url
      expect(page).to have_link 'yandex', href: new_url
    end

    scenario 'edits his question with errors' do
      click_on 'Edit question'
      fill_in 'Question', with: ''
      click_on 'Save'

      expect(page).to have_content "Body can't be blank"
    end

    scenario "tries to edit other user's question" do
      visit question_path(other_question)

      expect(page).to_not have_link 'Edit question'
    end
  end

  scenario 'Unauthenticated can not edit question' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit question'
  end
end
