# frozen_string_literal: true

require 'rails_helper'

feature 'User can view a list of questions', "
  In order to find a question
  As an user
  I'd like to be able to view questions
" do
  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 3, user:) }

  scenario 'User views questions' do
    visit user_questions_path(user)

    questions.each do |question|
      expect(page).to have_content question.title
    end
  end
end
