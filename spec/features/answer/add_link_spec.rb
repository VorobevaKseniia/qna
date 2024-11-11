require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an answer's author
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user_id: user.id) }
  given!(:answer) { create(:answer, question_id: question.id, user_id: user.id) }
  given(:shoulda) {'http://matchers.shoulda.io/docs/v6.4.0/'}
  given(:google) {'https://www.google.com'}

  background do
    sign_in(user)
    visit question_path(question)
  end

  scenario 'User adds link when asking an answer', js: true do
    within '.new-answer' do
      fill_in 'Body', with: 'Answer body'

      click_on 'Add link'
      within all('.nested-fields').first do
        fill_in 'Link name', with: 'Shoulda'
        fill_in 'Url', with: shoulda
      end

      click_on 'Add link'
      within all('.nested-fields').last do
        fill_in 'Link name', with: 'Google'
        fill_in 'Url', with: google
      end

      click_on 'Answer'
    end
    within "#answer-#{answer.id} .links" do
      expect(page).to have_link('Shoulda', href: shoulda)
      expect(page).to have_link('Google', href: google)
    end
  end

  scenario 'User adds links when editing a answer', js: true do
    within "#answer-#{answer.id}" do
      click_on 'Edit'
      click_on 'Add link'

      fill_in 'Link name', with: 'Google'
      fill_in 'Url', with: google

      click_on 'Save'
      expect(page).to have_link 'Google', href: google
    end
  end
end