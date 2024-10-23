require 'rails_helper'

feature 'User can edit their answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user_id: user.id) }
  given!(:answer) { create(:answer, question_id: question.id, user_id: user.id) }
  given!(:non_author) { create(:user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
      within '.answers' do
        click_on 'Edit'
      end
    end

    scenario 'edits their answer' do
      within '.answers' do
        fill_in 'Body', with: 'edited body'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited body'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits their answer with errors' do
      within '.answers' do
        fill_in 'Body', with: ''
        click_on 'Save'
      end
      expect(page).to have_content "Body can't be blank"
    end

    # scenario 'edits their answer with attached files' do
    #   within '.answers' do
    #     fill_in 'Body', with: 'edited body'
    #     attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
    #     click_on 'Save'
    #   end
    #   expect(page).to have_link 'rails_helper.rb'
    #   expect(page).to have_link 'spec_helper.rb'
    # end
  end

  scenario "Authenticated user tries to edit other user's answer", js: true do
    sign_in(non_author)
    visit question_path(question)
    within '.answers' do
      expect(page).to_not have_link 'Edit'
    end
  end

  scenario 'Unauthenticated user can not edit answer' do
    visit question_path(question)
    within '.answers' do
      expect(page).to_not have_link 'Edit'
    end
  end
end