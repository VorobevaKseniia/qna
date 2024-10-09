require 'rails_helper'

feature 'User can delete a question file', %q{
  In order to delete a question file
  As an author of question
  I'd like to be able to remove a question file
} do
  given!(:user) { create(:user) }
  given!(:author) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:file) { fixture_file_upload("#{Rails.root}/spec/rails_helper.rb") }
  background { question.files.attach(file) }

  describe 'Authenticated user' do
    scenario 'tries  to delete a question file they created', js: true do
      sign_in(author)
      visit question_path(question)

      accept_confirm 'Are you sure?' do
        click_on 'X'
      end
      expect(page).to have_content 'Your file successfully deleted.'
    end

    scenario 'tries to delete a question file not they created' do
      sign_in(user)
      visit question_path(question)

      expect(page).to_not have_link 'X'
    end
  end

  scenario 'Unauthenticated user tries to delete a question file' do
    visit question_path(question)
    expect(page).to_not have_link 'X'
  end
end
