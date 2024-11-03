# frozen_string_literal: true

require 'rails_helper'

feature 'User can vote for question/answer', "
  In order to mark the usefulness of a question/answer
  As an authenticated user
  I'd like to be able to vote for question/answer
" do
  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question, user_id: author.id) }
  given!(:answer) { create(:answer, question_id: question.id, user_id: author.id) }

  shared_examples 'votable tests' do |votable_type|
    let(:votable) { send(votable_type) }

    describe 'Authenticated user ', js: true do
      describe 'author answer/question' do
        background do
          sign_in(user)
          visit question_path(question)
        end

        scenario 'does not vote for answer/question' do
          within ".rating-#{votable.class.name.downcase}-row" do
            click_on '▲'
            expect(page).to have_selector("#rating-#{votable.id}", text: '0')
          end
        end
      end

      describe 'not author' do
        background do
          sign_in(user)
          visit question_path(question)
        end

        scenario 'votes for answer/question' do
          within ".rating-#{votable.class.name.downcase}-row" do
            click_on '▲'
            expect(page).to have_selector("#rating-#{votable.id}", text: '1')
          end
        end

        scenario "changes vote's value" do
          within ".rating-#{votable.class.name.downcase}-row" do
            click_button '▲'
            expect(page).to have_selector("#rating-#{votable.id}", text: '1')

            click_button '▼'
            expect(page).to have_selector("#rating-#{votable.id}", text: '-1')
          end
        end

        scenario 'deletes vote of answer/question' do
          within ".rating-#{votable.class.name.downcase}-row" do
            click_button '▲'
            expect(page).to have_selector("#rating-#{votable.id}", text: '1')

            click_button '▲'
            expect(page).to have_selector("#rating-#{votable.id}", text: '0', wait: 5)
          end
        end
      end
    end

    scenario 'Unauthenticated user tries to vote', js: true do
      visit question_path(question)
      within ".rating-#{votable.class.name.downcase}-row" do
        click_button '▲'
      end
      expect(page).to have_selector('.alert-box', text: 'You need to sign in')
    end
  end

  include_examples 'votable tests', :question
  include_examples 'votable tests', :answer
end
