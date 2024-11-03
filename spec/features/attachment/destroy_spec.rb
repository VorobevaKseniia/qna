require 'rails_helper'

feature 'User can delete file when editing a question/answer', %q{
  In order to delete a question/answer file
  As an author of question/answer
  I'd like to be able to remove a question/answer file
} do
  given!(:user) { create(:user) }
  given!(:author) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, question: question, user: author) }
  given!(:file) { fixture_file_upload("#{Rails.root}/spec/rails_helper.rb") }

  background do
    question.files.attach(file)
    answer.files.attach(file)
  end

  describe 'Question' do
    describe 'Authenticated user' do
      scenario 'tries  to delete a question file they created', js: true do
        sign_in(author)
        visit question_path(question)

        within '.question' do
          click_on 'Edit'
          accept_confirm 'Are you sure?' do
            click_on 'X'
          end
        end
        expect(page).to have_content 'Your file successfully deleted.'
        within '.question' do
          expect(page).to_not have_link(question.files.first.filename.to_s)
        end
      end

      scenario 'tries to delete a question file not they created' do
        sign_in(user)
        visit question_path(question)

        within '.question' do
          expect(page).to_not have_link 'X'
        end
      end
    end

    scenario 'Unauthenticated user tries to delete a question file' do
      visit question_path(question)
      within '.question' do
        expect(page).to_not have_link 'X'
      end
    end
  end

  describe 'Answer' do
    describe 'Authenticated user' do
      scenario 'tries to delete an answer file they created', js: true do
        sign_in(author)
        visit question_path(question)

        within '.answers' do
          click_on 'Edit'
          within '#files' do
            accept_confirm 'Are you sure?' do
              click_on 'X'
            end
          end
        end
        expect(page).to have_content 'Your file successfully deleted.'
        within ".answers #answer-#{answer.id}" do
          expect(page).to_not have_link(answer.files.first.filename.to_s)
        end
      end

      scenario 'tries to delete an answer file not they created' do
        sign_in(user)
        visit question_path(question)

        within '.answers' do
          expect(page).to_not have_link 'Edit'
        end
      end
    end

    scenario 'Unauthenticated user tries to delete an answer file' do
      visit question_path(question)
      within '.answers' do
        expect(page).to_not have_link 'Edit'
      end
    end
  end
end
