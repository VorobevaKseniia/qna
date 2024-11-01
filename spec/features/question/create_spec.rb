# frozen_string_literal: true

require 'rails_helper'

feature 'User can create a question', "
  In order to get an answer from a community
  As an authenticated user
  I'd like to be able to ask question
" do
  given(:user) { create(:user) }
  given(:guest) { create(:user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit user_questions_path(user)
      click_on 'Ask question'
    end

    scenario 'asks a question' do
      within '.question' do
        fill_in 'Title', with: 'Question title'
        fill_in 'Body', with: 'Question body'
      end
      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created.'
      expect(page).to have_content 'Question title'
      expect(page).to have_content 'Question body'
    end

    scenario 'asks a question with errors' do
      click_on 'Ask'
      expect(page).to have_content "Title can't be blank"
    end

    scenario 'asks a question with attached file' do
      within '.question' do
        fill_in 'Title', with: 'Question title'
        fill_in 'Body', with: 'Question body'
      end

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Ask'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    context 'multiple sessions' do
      scenario "question appears on another user's page", js: true do
        Capybara.using_session('user') do
          sign_in(user)
          visit user_questions_path(user)
        end

        Capybara.using_session('guest') do
          visit user_questions_path(guest)
        end

        Capybara.using_session('user') do
          click_on 'Ask question'

          within '.question' do
            fill_in 'Title', with: 'Question title'
            fill_in 'Body', with: 'Question body'
          end

          click_on 'Ask'
          expect(page).to have_content 'Your question successfully created.'
          expect(page).to have_content 'Question title'
          expect(page).to have_content 'Question body'
        end

        Capybara.using_session('guest') do
          expect(page).to have_content 'Question title'
        end
      end
    end
  end

  scenario 'Unauthenticated user tries to ask a question' do
    visit user_questions_path(user)
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in to write a question'
  end
end
