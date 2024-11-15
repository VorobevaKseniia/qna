# frozen_string_literal: true

require 'rails_helper'

feature 'User can create a subscription to a question', "
  In order to receive notifications of new answers
  As an authenticated user
  I want to be able to create subscription
" do
  given(:user) { create(:user) }
  given(:question) { create(:question, user_id: user.id) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'subscribes to the question' do
      click_on 'Subscribe'

      expect(current_path).to eq question_path(question)
      expect(page).to have_content 'You have subscribed to updates for this question.'
    end
  end

  scenario 'Unauthenticated user tries to subscribe to the question' do
    visit question_path(question)
    expect(page).to_not have_button 'Subscribe'
  end
end
