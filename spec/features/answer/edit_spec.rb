require 'rails_helper'

feature 'User can edit his answer', "
  In order to correct mistakes
  As an author of answer
  I'd like ot be able to edit my answer
" do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, author: user) }
  given!(:other_answer) { create(:answer, question: create(:question), author: create(:user)) }
  given!(:link) { create(:link, linkable: answer) }
  given(:new_url) { 'https://yandex.ru/' }

  describe 'Authenticated user', js: true do
    background do
      answer.files.attach(create_file_blob)
      login(user)

      visit question_path(question)
    end

    scenario 'edits his answer' do
      click_on 'Edit'

      within '.answers' do
        fill_in 'Your answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answer with new attached file' do
      within '.answers' do
        click_on 'Edit'
        attach_file 'File', %W[#{Rails.root}/spec/rails_helper.rb #{Rails.root}/spec/spec_helper.rb]
        click_on 'Save'
      end

      within '.answer-files' do
        expect(page).to have_link 'image.jpg'
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'edits his answer with new link' do
      within '.answers' do
        click_on 'Edit'
        click_on 'add link'

        within all('.nested-fields').last do
          fill_in 'Link name', with: 'yandex'
          fill_in 'Url', with: new_url
        end

        click_on 'Save'

        expect(page).to have_link 'google', href: link.url
        expect(page).to have_link 'yandex', href: new_url
      end
    end

    scenario 'edits his answer with errors' do
      click_on 'Edit'

      within '.answers' do
        fill_in 'Your answer', with: ''
        click_on 'Save'
      end

      within '.answer .errors' do
        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario "tries to edit other user's answer" do
      visit question_path(other_answer.question)

      expect(page).to_not have_link 'Edit'
    end
  end

  scenario 'Unauthenticated can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end
end
