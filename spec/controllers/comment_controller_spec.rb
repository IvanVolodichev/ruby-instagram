# spec/controllers/comments_controller_spec.rb

require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:user_post) { create(:post, user: user) }
  let(:valid_attributes) { { text: 'Valid comment', post_id: user_post.id } }
  let(:invalid_attributes) { { text: '', post_id: user_post.id } }

  before { sign_in user }

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new comment' do
        expect {
          post :create, params: valid_attributes
        }.to change(Comment, :count).by(1)
      end

      it 'redirects to the post with success notice' do
        post :create, params: valid_attributes
        expect(response).to redirect_to(post_path(id: user_post.id))
        expect(flash[:notice]).to eq('Комментарий успешно добавлен')
      end
    end

    context 'with invalid parameters' do
      it 'does not create a comment' do
        expect {
          post :create, params: invalid_attributes
        }.not_to change(Comment, :count)
      end

      it 'redirects to the post with error alert' do
        post :create, params: invalid_attributes
        expect(response).to redirect_to(post_path(id: user_post.id))
        expect(flash[:alert]).to eq('Произошла ошибка при добавлении комментария')
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:comment) { create(:comment, user: user, post: user_post) }

    context 'when user is the owner' do
      it 'destroys the comment' do
        expect {
          delete :destroy, params: { id: comment.id, post_id: user_post.id }
        }.to change(Comment, :count).by(-1)
      end

      it 'redirects with success notice' do
        delete :destroy, params: { id: comment.id, post_id: user_post.id }
        expect(response).to redirect_to(post_path(id: user_post.id))
        expect(flash[:notice]).to eq('Комментарий был удалён')
      end
    end

    context 'when user is not the owner' do
      before { sign_in other_user }

      it 'does not destroy the comment' do
        expect {
          delete :destroy, params: { id: comment.id, post_id: user_post.id }
        }.not_to change(Comment, :count)
      end

      it 'redirects with access error' do
        delete :destroy, params: { id: comment.id, post_id: user_post.id }
        expect(response).to redirect_to(user_post)
        expect(flash[:error]).to eq('У вас нет прав на удаление этого коментария')
      end
    end

    context 'when destroy fails' do
      before do
        allow_any_instance_of(Comment).to receive(:destroy).and_return(false)
      end

      it 'redirects with error alert' do
        delete :destroy, params: { id: comment.id, post_id: user_post.id }
        expect(response).to redirect_to(post_path(id: user_post.id))
        expect(flash[:alert]).to eq('Произошла ошибка при удалении комментария')
      end
    end
  end

  describe 'private methods' do
    let!(:comment) { create(:comment, user: user, post: user_post) }

    describe '#check_owner' do
      before { sign_in other_user }

      it 'redirects when user is not owner' do
        delete :destroy, params: { id: comment.id, post_id: user_post.id }
        expect(response).to redirect_to(user_post)
        expect(flash[:error]).to be_present
      end
    end
  end
end