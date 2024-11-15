# frozen_string_literal: true

require 'rails_helper'

feature 'User can unsubscribe from a question', %q{
  In order to receive no more emails
  As an authenticated user
  I'd like to be able to unsubscribe from a question
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:subscription) { create(:subscription, question: question, user: user) }

  scenario 'Authenticated user tries to unsubscribe from a question', js: true do
    sign_in(user)
    visit question_path(question)

    accept_confirm do
      click_on 'Unsubscribe'
    end

    expect(page).to have_content 'You have unsubscribed from updates for this question.'
  end

  scenario 'Unauthenticated user tries to unsubscribe from a question' do
    visit question_path(question)
    expect(page).to_not have_button 'Unsubscribe'
  end
end
