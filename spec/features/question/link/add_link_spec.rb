require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given(:gist_url) {'https://gist.github.com/VorobevaKseniia/0a6360fe6375372149c7ff3b9478c3cc'}
  given(:google) {'https://www.google.com'}

  scenario 'User adds links when asks question', js: true do
    sign_in(user)
    visit new_user_question_path(user)

    fill_in 'Title', with: 'Question title'
    fill_in 'Body', with: 'Question body'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url
    click_on 'Add link'

    within all('.nested-fields').last do
      fill_in 'Link name', with: 'Google'
      fill_in 'Url', with: google
    end
    click_on 'Ask'
    expect(page).to have_link('My gist', href: gist_url)
    expect(page).to have_link('Google', href: google)
  end
end