# frozen_string_literal: true

require 'rails_helper'

feature 'User can use the search bar', "
  In order to find a question/answer/comment
  As an user
  I want to use the search bar
" do
  given!(:user) { create(:user, email: 'my_user@example.com') }
  given!(:question) { create(:question, title: 'My question', body: 'My question body', user: user) }
  given!(:answer) { create(:answer, body: 'My answer body', question: question, user: user) }
  given!(:comment) { create(:comment, body: 'My comment body', commentable: question, user: user) }

  background { visit root_path }

  scenario 'searches for “My”' do
    fill_in 'query', with: 'My'
    click_on 'Search'

    expect(page).to have_content 'My question'
    expect(page).to have_content 'My question body'
    expect(page).to have_content 'My answer body'
    expect(page).to have_content 'My comment body'
    expect(page).to have_content 'my_user@example.com'
  end

  scenario 'searches question for “My”' do
    fill_in 'query', with: 'My'
    select 'Question', from: 'scope'
    click_on 'Search'

    expect(page).to have_content 'My question'
    expect(page).to have_content 'My question body'
    expect(page).to_not have_content 'My answer body'
    expect(page).to_not have_content 'My comment body'
    expect(page).to_not have_content 'my_user@example.com'
  end
end
