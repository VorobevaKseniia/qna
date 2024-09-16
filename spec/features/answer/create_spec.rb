require 'rails_helper'

feature 'User can create an answer', %q{
  In order to help with question
  As an authenticated user
  I'd like to be able to answer the question
}do

  given(:user) { create(:user) }
  given(:question) { create(:question, user_id: user.id) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'answers the question' do
      fill_in 'Body', with: 'answer answer answer'
      click_on 'Answer'

      expect(page).to have_content 'Your answer successfully created.'
      expect(page).to have_content 'answer answer answer'
    end

    scenario 'answers the question with errors' do
      click_on 'Answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries to answer the question' do
    visit question_path(question)
    click_on 'Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end