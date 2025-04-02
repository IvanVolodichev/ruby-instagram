# spec/controllers/like_controller_spec.rb
require 'rails_helper'

RSpec.describe LikesController, type: :controller do
  let(:new_post) { create(:post) }
  let(:user) { create(:user) }

  before { sign_in user }

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a like and returns JSON' do
        
				post :create, params: { post_id: new_post.id }, format: :json

        new_post.reload
				
        expect(response).to have_http_status(:ok)

        expect(JSON.parse(response.body)).to eq(
          'liked' => true,
          'likes_count' => new_post.likes.count
        )
      end
    end

    context 'when user already liked the post' do
      it 'does not create duplicate like' do
        
				post :create, params: { post_id: new_post.id }, format: :json
				post :create, params: { post_id: new_post.id }, format: :json
				expect(new_post.likes.count).to eq(1)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when like exists' do
      

      it 'destroys the like and returns JSON' do
        
				post :create, params: { post_id: new_post.id }, format: :json
				delete :destroy, params: { post_id: new_post.id }, format: :json

        new_post.reload
        expect(response).to have_http_status(:ok)
				expect(new_post.likes.count).to eq(0)
        expect(JSON.parse(response.body)).to eq(
          'liked' => false,
          'likes_count' => new_post.likes.count
        )
      end
    end

    context 'when like does not exist' do
      it 'returns not found status' do
        delete :destroy, params: { post_id: new_post.id }, format: :json
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end