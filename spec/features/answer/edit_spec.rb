require 'rails_helper'

feature 'User can edit their answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user_id: user.id) }
  given!(:answer) { create(:answer, question_id: question.id, user_id: user.id) }
  given!(:non_author) { create(:user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'edits their answer' do
      click_on 'Edit'

      within '.answers' do
        fill_in 'Body', with: 'edited body'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited body'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits their answer with errors'
    scenario "tries to edit other user's answer"
  end

  scenario 'Unauthenticated user can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

end