require 'rails_helper'

feature 'User can add new links when edit question', %q{
  In order to provide additional info to my question
  As an author of question
  I'd like to be able to add new links
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given(:google) {'https://www.google.com'}

  # scenario 'User adds link when edit question', js: true do
  #   sign_in(user)
  #
  #   visit question_path(question)
  #
  #   within '.question' do
  #     click_on 'Edit'
  #     click_on 'add link'
  #
  #     fill_in 'Link name', with: 'Google'
  #     fill_in 'Url', with: google
  #
  #     click_on 'Save'
  #     expect(page).to have_link 'Google', href: google
  #   end
  # end
end