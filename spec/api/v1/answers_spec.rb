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
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

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

  describe 'POST /api/v1/questions/:id/answers' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      let(:api_response) { json['answer'] }

      context 'request with valid params' do
        before { post api_path, params: { access_token: access_token.token, answer: { body: "new body" }, user: user, question: question } }

        it 'returns answer' do
          expect(api_response['body']).to eq "new body"
          expect(api_response['user_id']).to eq user.id.as_json
        end
      end

      context 'request with invalid params' do
        before { post api_path, params: { access_token: access_token.token, answer: { body: nil }, user: user, question: question } }

        it 'returns error message' do
          expect(json['errors']).to eq ["Body can't be blank"]
        end
      end
    end
  end

  describe 'PATCH /api/v1/answers/:id' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question, user: user) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :patch }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      let(:api_response) { json['answer'] }

      context 'request with valid params' do
        before { patch api_path, params: {id: answer, access_token: access_token.token, answer: { body: "updated body" } }}

        it 'returns answer' do
          expect(api_response['body']).to eq "updated body"
        end
      end

      context 'request with invalid params' do
        before { patch api_path, params: {id: answer, access_token: access_token.token, answer: { body: nil }, user_id: user, question: question }}

        it "doesn't change answer and returns error message" do
          expect(json['errors']).to include("Body can't be blank")
        end
      end
    end
  end

  describe 'DELETE /api/v1/answers/:id' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question, user: user) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      let(:api_response) { json['answer'] }

      context 'request with valid params' do
        before { delete api_path, params: {id: answer, access_token: access_token.token }}

        it 'delete answer' do
          expect(Answer.where(id: answer.id)).to eq []
        end
      end
    end
  end
end
