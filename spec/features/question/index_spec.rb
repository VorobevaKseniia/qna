require 'rails_helper'

feature 'User can view a list of questions', %q{
  In order to find a question
  As an user
  I'd like to be able to view questions
}do

  given!(:questions) { create_list(:question, 3) }

  scenario 'User views questions' do
    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.title
    end
  end
end