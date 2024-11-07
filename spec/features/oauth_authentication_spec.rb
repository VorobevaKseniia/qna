require 'rails_helper'

feature 'OAuth Authentication', type: :feature do
  context 'GitHub authentication' do
    scenario 'user can sign in with GitHub' do
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
                                                                    provider: 'github',
                                                                    uid: '12345',
                                                                    info: { email: 'github_user@example.com' }
                                                                  })
      visit new_user_session_path
      click_on 'Sign in with GitHub'

      expect(page).to have_content 'Successfully authenticated from Github account.'
      expect(page).to have_content 'github_user@example.com'
    end
  end

  context 'Facebook authentication' do
    scenario 'user can sign in with Facebook' do
      OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
                                                                      provider: 'facebook',
                                                                      uid: '67890',
                                                                      info: { email: 'facebook_user@example.com' }
                                                                    })
      visit new_user_session_path
      click_on 'Sign in with Facebook'

      expect(page).to have_content 'Successfully authenticated from Facebook account.'
      expect(page).to have_content 'facebook_user@example.com'
    end
  end

  context 'when authentication fails' do
    context 'via Github' do
      scenario 'user sees an error message' do
        OmniAuth.config.mock_auth[:github] = :invalid_credentials

        visit new_user_session_path
        click_on 'Sign in with GitHub'

        expect(page).to have_content 'Could not authenticate you from GitHub because "Invalid credentials".'
      end
    end

    context 'via Facebook' do
      scenario 'user sees an error message' do
        OmniAuth.config.mock_auth[:facebook] = :invalid_credentials

        visit new_user_session_path
        click_on 'Sign in with Facebook'

        expect(page).to have_content 'Could not authenticate you from Facebook because "Invalid credentials".'
      end
    end
  end
end
