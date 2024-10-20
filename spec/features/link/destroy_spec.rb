require 'rails_helper'

feature 'User can delete link when editing a question/answer', %q{
  In order to delete a question/answer link
  As an author of question/answer
  I'd like to be able to remove a question/answer link
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:link_question) { create(:link, linkable: question) }
  given!(:link_answer) { create(:link, linkable: answer) }

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User deletes links when editing a question', js: true do
    within '.question' do
      click_on 'Edit'
      click_on 'X'
      click_on 'Save'
      expect(page).to_not have_link link_question.name, href: link_question.url
    end
  end

  scenario 'User deletes links when editing an answer', js: true do
    within '.answers' do
      click_on 'Edit'
      click_on 'X'
      click_on 'Save'
      expect(page).to_not have_link link_answer.name, href: link_answer.url
    end
  end
end

