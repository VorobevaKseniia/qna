require 'rails_helper'

feature 'User can delete an answer file', %q{
  In order to delete an answer file
  As an author of answer
  I'd like to be able to remove an answer file
} do
  given!(:user) { create(:user) }
  given!(:author) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: author) }
  given!(:file) { fixture_file_upload("#{Rails.root}/spec/rails_helper.rb") }
  background { answer.files.attach(file) }

  describe 'Authenticated user' do
    scenario 'tries to delete an answer file they created', js: true do
      sign_in(author)
      visit question_path(question)

      within '.answers' do
        accept_confirm 'Are you sure?' do
          click_on 'X'
        end
      end
      expect(page).to have_content 'Your file successfully deleted.'
    end

    scenario 'tries to delete an answer file not they created' do
      sign_in(user)
      visit question_path(question)

      within '.answers' do
        expect(page).to_not have_link 'X'
      end
    end
  end

  scenario 'Unauthenticated user tries to delete an answer file' do
    visit question_path(question)
    within '.answers' do
      expect(page).to_not have_link 'X'
    end
  end
end
