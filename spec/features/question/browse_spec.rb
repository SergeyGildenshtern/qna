require 'rails_helper'

feature 'User can browse questions', "
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to ask the question
" do
  given(:user) { create(:user) }
  given!(:questions) { [create(:question), create(:question), create(:question)] }

  background { visit questions_path }

  scenario 'Authenticated user tries to browse questions' do
    login(user)

    questions.each { |q| expect(page).to have_content q.title }
  end

  scenario 'Unauthenticated user tries to browse questions' do
    questions.each { |q| expect(page).to have_content q.title }
  end
end
