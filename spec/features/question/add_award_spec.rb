require 'rails_helper'

feature 'User can add award to question', %q{
  In order to reward a user for answer
  As an question's author
  I'd like to be able to add award
} do
  given(:user) { create(:user) }

  background do
    sign_in(user)
    visit new_user_question_path(user)
    within '.question' do
      fill_in 'Title', with: 'Question title'
      fill_in 'Body', with: 'Question body'
    end
  end

  scenario 'User adds award' do
    within '.award' do
      fill_in 'Title', with: 'Award for the best answer'
      attach_file 'Image', "#{Rails.root}/app/assets/images/award.png"
    end
    click_on 'Ask'

    expect(page).to have_content('Award for the best answer')
    expect(page).to have_css("img[src*='award.png']")
  end

  scenario 'User adds award with invalid title' do
    within '.award' do
      attach_file 'Image', "#{Rails.root}/app/assets/images/award.png"
    end
    click_on 'Ask'
    expect(page).to have_content("Award title can't be blank")
  end

  scenario 'User adds award with invalid image' do
    within '.award' do
      fill_in 'Title', with: 'Award for the best answer'
    end
    click_on 'Ask'
    expect(page).to have_content("Award image can't be blank")
  end
end