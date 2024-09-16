require 'rails_helper'

feature 'User can view a question and its answers', %q{
  In order to find an answer to the question
  As a user
  I'd like to be able to view a question and its answers
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'User views question and its answers' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    question.answers.each do |answer|
      expect(page).to have_content answer.body
    end
  end
end