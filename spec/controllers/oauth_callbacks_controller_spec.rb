require 'rails_helper'

RSpec.describe OauthCallbacksController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe 'Github' do
    let(:oauth_data) { OmniAuth::AuthHash.new('provider' => 'github', 'uid' => '123') }

    before { request.env['omniauth.auth'] = oauth_data }

    it 'finds user from oauth data' do
      expect(User).to receive(:find_for_oauth).with(oauth_data)
      get :github
    end

    context 'user exists' do
      let!(:user) { create(:user) }

      before do
        allow(User).to receive(:find_for_oauth).and_return(user)
        get :github
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
        get :github
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end

      it 'does not log in the user' do
        expect(subject.current_user).to be_nil
      end
    end
  end

  describe 'Facebook' do
    let(:oauth_data) { OmniAuth::AuthHash.new('provider' => 'facebook', 'uid' => '123') }

    before { request.env['omniauth.auth'] = oauth_data }

    it 'finds user from oauth data' do
      expect(User).to receive(:find_for_oauth).with(oauth_data)
      get :facebook
    end

    context 'user exists' do
      let!(:user) { create(:user) }

      before do
        allow(User).to receive(:find_for_oauth).and_return(user)
        get :facebook
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
        get :facebook
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
