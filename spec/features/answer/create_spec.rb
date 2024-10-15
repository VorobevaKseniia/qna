# frozen_string_literal: true

require 'rails_helper'

feature 'User can create an answer', "
  In order to help with question
  As an authenticated user
  I want to be able to create answers
" do
  given(:user) { create(:user) }
  given(:question) { create(:question, user_id: user.id) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'answers the question' do
      fill_in 'Body', with: 'answer answer answer'
      click_on 'Answer'

      expect(current_path).to eq question_path(question)
      within '.answers' do
        expect(page).to have_content 'answer answer answer'
      end
    end

    scenario 'answers the question with errors' do
      click_on 'Answer'

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'answers the question with attached file' do
      fill_in 'Body', with: 'answer answer answer'
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Answer'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario 'Unauthenticated user tries to answer the question' do
    visit question_path(question)
    click_on 'Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
