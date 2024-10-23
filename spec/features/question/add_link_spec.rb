require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user_id: user.id)}
  given(:shoulda) {'http://matchers.shoulda.io/docs/v6.4.0/index.html'}
  given(:google) {'https://www.google.com'}

  background { sign_in(user) }

  scenario 'User adds links when creating a new question', js: true do
    visit new_user_question_path(user)

    within '.question' do
      fill_in 'Title', with: 'Question title'
      fill_in 'Body', with: 'Question body'
    end

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

    click_on 'Ask'

    expect(page).to have_link('Shoulda', href: shoulda)
    expect(page).to have_link('Google', href: google)
  end

  scenario 'User adds links when editing a question', js: true do
    visit question_path(question)

    within '.question' do
      click_on 'Edit'
      click_on 'Add link'

      fill_in 'Link name', with: 'Google'
      fill_in 'Url', with: google

      click_on 'Save'
      expect(page).to have_link 'Google', href: google
    end
  end
end
