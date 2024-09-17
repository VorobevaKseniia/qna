# frozen_string_literal: true

require 'rails_helper'

feature 'User can delete a question', "
  In order to delete a question
  As a user
  I'd like to be able to destroy a question
" do
  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question, user: author) }

  describe 'Authenticated user' do
    scenario 'tries to delete their question' do
      sign_in(author)
      visit question_path(question)
      click_on 'Delete question'

      expect(page).to have_content 'Your question successfully deleted.'
    end

    scenario 'tries to delete not their question' do
      sign_in(user)
      visit question_path(question)

      expect(page).to_not have_link 'Delete question'
    end
  end

  scenario 'Unauthenticated user tries to delete the question' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete question'
  end
end
