require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  let(:user) { create(:user) }
  let(:other_user) { create(:user) }
  let(:user_post) { create(:post, user: user) }
  let(:valid_params) { { description: 'Test post', images: [fixture_file_upload('test_image1.jpg')] } }
  let(:invalid_params) { { description: '', images: [] } }

  describe 'GET #index' do
    context 'with existing user' do
      before do
        create_list(:post, 3, user: user)
        get :index, params: { user_id: user.id }
      end

      it 'assigns correct posts' do
        expect(assigns(:posts)).to eq(user.posts.order(created_at: :desc))
      end

      it 'renders index template' do
        expect(response).to render_template(:index)
      end
    end

    context 'with non-existing user' do
      it 'raises record not found' do
        expect { get :index, params: { user_id: 0 } }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'GET #show' do
    context 'with existing post' do
      before { get :show, params: { id: user_post.id } } 

      it 'assigns correct post' do
        expect(assigns(:post)).to eq(user_post) 
      end

      it 'renders show template' do
        expect(response).to render_template(:show)
      end
    end

    context 'with non-existing post' do
      it 'raises record not found' do
        expect { get :show, params: { id: 0 } }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe 'POST #create' do
    before { sign_in user }

    context 'with valid params' do
      it 'creates new post' do
        expect {
          post :create, params: { post: valid_params } 
        }.to change(Post, :count).by(1)
      end

      it 'redirects to post with notice' do
        post :create, params: { post: valid_params }
        expect(response).to redirect_to(assigns(:post))
        expect(flash[:notice]).to be_present
      end
    end

    context 'with invalid params' do
      it 'does not create post' do
        expect {
          post :create, params: { post: invalid_params }
        }.not_to change(Post, :count)
      end

      it 'renders new template' do
        post :create, params: { post: invalid_params }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET #edit' do
    context 'when owner' do
      before do
        sign_in user
        get :edit, params: { id: user_post.id } 
      end

      it 'assigns correct post' do
        expect(assigns(:post)).to eq(user_post) 
      end

      it 'renders edit template' do
        expect(response).to render_template(:edit)
      end
    end

    context 'when not owner' do
      before do
        sign_in other_user
        get :edit, params: { id: user_post.id } 
      end

      it 'redirects with alert' do
        expect(response).to redirect_to(user_post) 
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe 'PATCH #update' do
    before { sign_in user }

    context 'with valid params' do
      before do
        patch :update, params: { id: user_post.id, post: valid_params } 
      end

      it 'updates post' do
        user_post.reload 
        expect(user_post.description).to eq('Test post')
      end

      it 'redirects to post with notice' do
        expect(response).to redirect_to(user_post) 
        expect(flash[:notice]).to be_present
      end
    end

    context 'with invalid params' do
      it 'does not update post' do
        patch :update, params: { id: user_post.id, post: invalid_params } 
        user_post.reload
        expect(user_post.description).not_to be_blank
      end

      it 'renders edit template' do
        patch :update, params: { id: user_post.id, post: invalid_params } 
        expect(response).to render_template(:edit)
      end
    end

    context 'when not owner' do
      before do
        sign_in other_user
        patch :update, params: { id: user_post.id, post: valid_params } 
      end

      it 'redirects with alert' do
        expect(response).to redirect_to(user_post) 
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:user_post) { create(:post, user: user) } 

    context 'when owner' do
      before { sign_in user }

      it 'destroys post' do
        expect {
          delete :destroy, params: { id: user_post.id } 
        }.to change(Post, :count).by(-1)
      end

      it 'redirects to root with notice' do
        delete :destroy, params: { id: user_post.id } 
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to be_present
      end
    end

    context 'when not owner' do
      before do
        sign_in other_user
        delete :destroy, params: { id: user_post.id } 
      end

      it 'does not destroy post' do
        expect(Post.exists?(user_post.id)).to be true 
      end

      it 'redirects with alert' do
        expect(response).to redirect_to(user_post) 
        expect(flash[:alert]).to be_present
      end
    end

    context 'with error' do
      before do
        sign_in user
        allow_any_instance_of(Post).to receive(:destroy).and_return(false)
        delete :destroy, params: { id: user_post.id } 
      end

      it 'redirects with alert' do
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to be_present
      end
    end
  end
end