require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { 'ACCEPT' => 'application/json' } }

  describe 'GET /api/v1/questions/:id/answers' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:answers) { create_list(:answer, 3, question: question, user: user) }
      let(:answer) { answers.first }
      let(:answer_response) { json['answers'].first }

      before do
        get api_path, params: { access_token: access_token.token }, headers: headers
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['answers'].size).to eq 3
      end

      it 'returns all public fields' do
        %w[id body created_at updated_at].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(answer_response['user']['id']).to eq question.user.id
      end
    end
  end

  describe 'GET /api/v1/answers/:id' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question, user: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:comments) { create_list(:comment, 3, commentable: answer, user: user) }
      let!(:links) { create_list(:link, 3, linkable: answer) }
      let!(:files) do
        answer.files.attach(
          io: File.open(Rails.root.join('spec/rails_helper.rb')),
          filename: 'rails_helper.rb'
        )
        answer.files.attach(
          io: File.open(Rails.root.join('spec/spec_helper.rb')),
          filename: 'spec_helper.rb'
        )
      end

      let(:api_response) { json['answer'] }

      before do
        get api_path, params: { access_token: access_token.token }, headers: headers
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields for answer' do
        %w[id body question_id user_id created_at updated_at].each do |attr|
          expect(api_response[attr]).to eq answer.send(attr).as_json
        end
      end

      it 'contains associated comments, links, and files' do
        expect(api_response['comments'].size).to eq 3
        expect(api_response['links'].size).to eq 3
        expect(api_response['attached_files'].size).to eq answer.files.size
      end
    end
  end
end
