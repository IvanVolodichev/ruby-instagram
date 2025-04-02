# spec/controllers/followers_controller_spec.rb

require 'rails_helper'

RSpec.describe FollowersController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  
  before { sign_in user }

  describe 'POST #follow' do
    context 'with valid params' do
      it 'creates a new follow relationship' do
        
        post :follow, params: { user_id: other_user.id }
        
        expect(response).to redirect_to(user_posts_path(user_id: other_user.id))
        expect(flash[:notice]).to eq('Вы подписались на аккаунт')
      end

      it 'handles existing follow relationship' do
        existing_follow = create(:follow_relationship, follower: user, following: other_user)
        allow(Follower).to receive(:find_or_initialize_by).and_return(existing_follow)
        
        post :follow, params: { user_id: other_user.id }
        
        expect(response).to redirect_to(user_posts_path(user_id: other_user.id))
        expect(flash[:alert]).to eq('Не удалось подписаться')
      end
    end

    context 'when trying to self-follow' do
      it 'blocks the action and shows alert' do
        post :follow, params: { user_id: user.id }
        
        expect(response).to redirect_to(user_posts_path(user_id: user.id))
        expect(flash[:alert]).to eq('Нельзя подписаться на самого себя')
      end
    end
  end

  describe 'DELETE #unfollow' do
    context 'with existing follow relationship' do
      it 'destroys the follow relationship' do
        follow = create(:follow_relationship, follower: user, following: other_user)
        delete :unfollow, params: { user_id: other_user.id }
        
        expect(response).to redirect_to(user_posts_path(user_id: other_user.id))
        expect(flash[:notice]).to eq('Вы успешно отписались')
      end

      it 'handles destruction failure' do
        allow(Follower).to receive(:find_by).and_return(nil)
        
        delete :unfollow, params: { user_id: other_user.id }
        
        expect(response).to redirect_to(user_posts_path(user_id: other_user.id))
        expect(flash[:alert]).to eq('Что-то пошло не так при отписке')
      end
    end
  end
end