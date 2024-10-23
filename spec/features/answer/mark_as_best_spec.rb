require 'rails_helper'

feature 'User can choose the best answer', %q{
  In order to mark the answer that helped with the solution
  As an author of question
  I'd like to be able to choose the best answer for question
} do

  given!(:author) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, question: question, user: author) }
  given!(:user) { create(:user) }
  given!(:award) { create(:award, image: fixture_file_upload("#{Rails.root}/app/assets/images/award.png"),
                        question: question) }

  describe 'Authenticated user' do
    scenario 'tries to choose best answer for their question', js: true do
      sign_in(author)
      visit question_path(question)
      click_on 'Mark as best'

      expect(page).to have_content 'Best answer'
    end

    scenario 'tries to choose best answer not for their question', js: true do
      sign_in(user)
      visit question_path(question)
      expect(page).to_not have_link 'Mark as best'
    end
  end

  scenario 'Unauthenticated user tries to choose best answer', js: true do
    visit question_path(question)
    expect(page).to_not have_link 'Mark as best'
  end
end