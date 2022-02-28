require 'rails_helper'

feature 'User can browse answers', "
  In order to find out community answers
  I'd like to be able to browse question answers
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answers) {
    [create(:answer, question: question),
     create(:answer, question: question),
     create(:answer, question: question)]
  }

  scenario 'Authenticated user tries to browse question answers' do
    login(user)
    visit question_path(question)

    answers.each do |a|
      expect(page).to have_content a.body
      expect(page).to have_content a.question.title
      expect(page).to have_content a.question.body
    end
  end

  scenario 'Unauthenticated user tries to browse question answers' do
    visit question_path(question)

    answers.each do |a|
      expect(page).to have_content a.body
      expect(page).to have_content a.question.title
      expect(page).to have_content a.question.body
    end
  end
end
