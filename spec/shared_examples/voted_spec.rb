# RSpec.shared_examples 'voted' do |votable_type|
#   let(:user) { create(:user) }
#   let(:votable) { create(votable_type, user: user) }
#
#   describe 'POST #create' do
#     before { login(user) }
#
#     context 'if vote new' do
#       it 'saves a new vote in the database' do
#         expect {
#           post :create, params: { votable_type: votable_type.capitalize, votable_id: votable.id, value: 1 }, format: :json
#         }.to change(votable.votes, :count).by(1)
#       end
#
#       it 'returns status :created' do
#         post :create, params: { votable_type: votable_type.capitalize, votable_id: votable.id, value: 1 }, format: :json
#         expect(response).to have_http_status(:created)
#       end
#
#       it 'returns the created vote as JSON' do
#         post :create, params: { votable_type: votable_type.capitalize, votable_id: votable.id, value: 1 }, format: :json
#         expect(JSON.parse(response.body)['id']).to eq(Vote.last.id)
#         expect(JSON.parse(response.body)['value']).to eq(Vote.last.value)
#       end
#     end
#
#     context 'if vote exist' do
#       before { votable.votes.create(user: user, value: 1) }
#
#       it "changes vote's value" do
#         expect {
#           post :create, params: { votable_type: votable.type, votable_id: votable.id, value: -1 }, format: :json
#         }.not_to change(votable.votes, :count)
#         expect(votable.votes.find_by(user: user).value).to eq(-1)
#       end
#
#       it 'returns status :created' do
#         post :create, params: { votable_type: votable.type, votable_id: votable.id, value: -1 }, format: :json
#         expect(response).to have_http_status(:created)
#       end
#
#       it 'returns the updated vote as JSON' do
#         post :create, params: { votable_type: votable.type, votable_id: votable.id, value: -1 }, format: :json
#         expect(JSON.parse(response.body)['value']).to eq(-1)
#       end
#     end
#   end
#
#   describe 'DELETE #destroy' do
#     let!(:vote) { create(:vote, votable_type: votable.type, votable_id: votable.id) }
#
#     it 'deletes the vote' do
#       expect { delete :destroy, params: { id: vote, votable_type: votable.type, votable_id: votable.id },
#                       format: :json }.to change(Vote, :count).by(-1)
#     end
#   end
# end
