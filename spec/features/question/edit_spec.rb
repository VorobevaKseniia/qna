require 'rails_helper'

feature 'User can edit their question', %q{
  In order to correct mistakes
  As an author of question
  I'd like to be able to edit my question
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user_id: user.id) }
  given!(:non_author) { create(:user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
      within '.question' do
        click_on 'Edit'
      end
    end

    scenario 'edits their question' do
      within '.question' do
        fill_in 'Title', with: 'edited title'
        fill_in 'Body', with: 'edited body'
        click_on 'Save'

        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
        expect(page).to have_content 'edited title'
        expect(page).to have_content 'edited body'
        expect(page).to_not have_selector 'text_field'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits their question with errors' do
      within '.question' do
        fill_in 'Title', with: ''
        fill_in 'Body', with: ''
        click_on 'Save'
      end
      expect(page).to have_content "Title can't be blank"
      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario "Authenticated user tries to edit other user's question", js: true do
    sign_in(non_author)
    visit question_path(question)
    within '.question' do
      expect(page).to_not have_link 'Edit'
    end
  end

  scenario 'Unauthenticated user can not edit question' do
    visit question_path(question)
    within '.question' do
      expect(page).to_not have_link 'Edit'
    end
  end
end