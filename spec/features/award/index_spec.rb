require 'rails_helper'

feature 'User can view a list of their awards', "
  In order to see their awards
  As an authenticated user
  I'd like to be able to view my awards
" do
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:award) { create(:award, image: fixture_file_upload("#{Rails.root}/app/assets/images/award.png"),
                            question: question, user: user) }

  scenario 'Authenticated user views awards' do
    sign_in(user)
    visit user_awards_path(user)

    expect(page).to have_content question.title
    expect(page).to have_content award.title
    expect(page).to have_css("img[src*='award.png']")
  end
end
