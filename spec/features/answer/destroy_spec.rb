# frozen_string_literal: true

require 'rails_helper'

feature 'User can delete an answer', %q{
  In order to delete an answer
  As an author of answer
  I'd like to be able to destroy an answer
} do
  given!(:user) { create(:user) }
  given!(:author) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, question: question, user: author) }

  describe 'Authenticated user' do
    scenario 'tries to delete their answer', js: true do
      sign_in(author)
      visit question_path(question)
      accept_confirm 'Are you sure?' do
        click_on 'Delete answer'
      end
      expect(page).to have_content 'Your answer successfully deleted.'
    end

    scenario 'tries to delete not their answer' do
      sign_in(user)
      visit question_path(question)

      expect(page).to_not have_link 'Delete answer'
    end
  end

  scenario 'Unauthenticated user tries to delete the answer' do
    visit question_path(question)
    expect(page).to_not have_link 'Delete answer'
  end
end
