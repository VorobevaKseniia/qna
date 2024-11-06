require 'rails_helper'

RSpec.describe OauthCallbacksController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  shared_examples 'OAuth provider callback' do |provider|
    let(:oauth_data) { OmniAuth::AuthHash.new('provider' => provider.to_s, 'uid' => '123') }

    describe "#{provider.to_s.capitalize}" do
      before { request.env['omniauth.auth'] = oauth_data }

      it 'finds user from oauth data' do
        expect(User).to receive(:find_for_oauth).with(oauth_data)
        get provider
      end

      context 'user exists' do
        let!(:user) { create(:user) }

        before do
          allow(User).to receive(:find_for_oauth).and_return(user)
          get provider
        end

        it 'logs in the user' do
          expect(subject.current_user).to eq user
        end

        it 'redirects to root path' do
          expect(response).to redirect_to root_path
        end
      end

      context 'user does not exist' do
        before do
          allow(User).to receive(:find_for_oauth)
          get provider
        end

        it 'redirects to root path' do
          expect(response).to redirect_to root_path
        end

        it 'does not log in the user' do
          expect(subject.current_user).to be_nil
        end
      end
    end
  end

  it_behaves_like 'OAuth provider callback', :github
  it_behaves_like 'OAuth provider callback', :facebook
end
