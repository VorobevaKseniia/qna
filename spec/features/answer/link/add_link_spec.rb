require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an answer's author
  I'd like to be able to add links
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user_id: user.id) }
  given(:gist_url) {'https://gist.github.com/VorobevaKseniia/0a6360fe6375372149c7ff3b9478c3cc'}
  given(:google) {'https://www.google.com'}

  scenario 'User adds link when asks answer', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Body', with: 'Answer body'
    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on 'Add link'

    within all('.nested-fields').last do
      fill_in 'Link name', with: 'Google'
      fill_in 'Url', with: google
    end

    click_on 'Answer'
    within '.answers' do
      expect(page).to have_link('My gist', href: gist_url)
      expect(page).to have_link('Google', href: google)
    end
  end
end