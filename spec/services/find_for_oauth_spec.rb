require 'rails_helper'

RSpec.describe Services::FindForOauth do
  let!(:user) { create(:user) }

  subject { Services::FindForOauth.new(auth) }

  shared_examples 'oauth provider tests' do |provider|
    context 'when user already has authorization' do
      let(:auth) { OmniAuth::AuthHash.new(provider: provider, uid: '123456', info: { email: user.email }) }

      it 'returns the user' do
        user.authorizations.create(provider: provider, uid: '123456')
        expect(subject.call).to eq user
      end
    end

    context 'when user does not have authorization' do
      context 'and user already exists' do
        let(:auth) { OmniAuth::AuthHash.new(provider: provider, uid: '123456', info: { email: user.email }) }

        it 'does not create a new user' do
          expect { subject.call }.to_not change(User, :count)
        end

        it 'creates an authorization for the user' do
          expect { subject.call }.to change(user.authorizations, :count).by(1)
        end

        it 'creates authorization with provider and uid' do
          authorization = subject.call.authorizations.first
          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'returns the user' do
          expect(subject.call).to eq user
        end
      end

      context 'and user does not exist' do
        let(:auth) { OmniAuth::AuthHash.new(provider: provider, uid: '123456', info: { email: 'new@user.com' }) }

        it 'creates a new user' do
          expect { subject.call }.to change(User, :count).by(1)
        end

        it 'returns the new user' do
          expect(subject.call).to be_a(User)
        end

        it 'fills user email' do
          user = subject.call
          expect(user.email).to eq auth.info[:email]
        end

        it 'creates an authorization for the new user' do
          user = subject.call
          expect(user.authorizations).to_not be_empty
        end

        it 'creates authorization with provider and uid' do
          authorization = subject.call.authorizations.first
          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
      end
    end
  end

  ['Github', 'Facebook'].each do |provider|
    include_examples 'oauth provider tests', provider
  end
end
