# frozen_string_literal: true

require 'rails_helper'

feature 'User can create a comment', "
  In order to comment answer/question
  As an authenticated user
  I want to be able to comment answer/question
" do
  given(:user) { create(:user) }
  given(:guest) { create(:user) }
  given(:question) { create(:question, user_id: user.id) }
  given!(:answer) { create(:answer, user_id: user.id, question_id: question.id) }

  describe 'Question' do
    describe 'Authenticated user', js: true do
      background do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'comments the question' do
        within '.question .new-comment' do
          fill_in 'comment[body]', with: 'comment'
          click_on 'Comment'
        end

        within '.question' do
          expect(page).to have_content 'comment'
        end
      end

      scenario 'comments the question with errors' do
        within '.question .new-comment' do
          click_on 'Comment'
        end

        within '.question' do
          expect(page).to have_content "Body can't be blank"
        end
      end

      context 'multiple sessions' do
        scenario "comment appears on another user's page", js: true do
          Capybara.using_session('user') do
            sign_in(user)
            visit question_path(question)
          end

          Capybara.using_session('guest') do
            visit question_path(question)
          end

          Capybara.using_session('user') do
            within '.question .new-comment' do
              fill_in 'comment[body]', with: 'comment'
              click_on 'Comment'
            end

            within '.question' do
              expect(page).to have_content 'comment'
            end
          end

          Capybara.using_session('guest') do
            within '.question' do
              expect(page).to have_content 'comment'
            end
          end
        end
      end
    end

    scenario 'Unauthenticated user tries to comment the question' do
      visit question_path(question)

      within '.question .new-comment' do
        click_on 'Comment'
      end
      expect(page).to have_content 'You need to sign in'
    end
  end

  describe 'Answer' do
    describe 'Authenticated user', js: true do
      background do
        sign_in(user)
        visit question_path(question)
      end

      scenario 'comments the answer' do
        within ".answer#answer-#{answer.id} .new-comment" do
          fill_in 'comment[body]', with: 'comment'
          click_on 'Comment'
        end

        within '.answers' do
          expect(page).to have_content 'comment'
        end
      end

      scenario 'comments the answer with errors' do
        within ".answer#answer-#{answer.id} .new-comment" do
          click_on 'Comment'
        end

        within '.answers' do
          expect(page).to have_content "Body can't be blank"
        end
      end

      context 'multiple sessions' do
        scenario "comment appears on another user's page", js: true do
          Capybara.using_session('user') do
            sign_in(user)
            visit question_path(question)
          end

          Capybara.using_session('guest') do
            visit question_path(question)
          end

          Capybara.using_session('user') do
            within ".answer#answer-#{answer.id} .new-comment" do
              fill_in 'comment[body]', with: 'comment'
              click_on 'Comment'
            end

            within '.answers' do
              expect(page).to have_content 'comment'
            end
          end

          Capybara.using_session('guest') do
            within '.answers' do
              expect(page).to have_content 'comment'
            end
          end
        end
      end
    end

    scenario 'Unauthenticated user tries to comment the answer' do
      visit question_path(question)
      within ".answer#answer-#{answer.id} .new-comment" do
        click_on 'Comment'
      end
      expect(page).to have_content 'You need to sign in'
    end
  end
end
