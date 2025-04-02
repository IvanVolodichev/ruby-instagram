require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe 'GET #index' do
    let!(:post1) { create(:post, created_at: 1.day.ago) }
    let!(:post2) { create(:post, created_at: Time.current) }

    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end

    it 'assigns @posts in descending order by creation time' do
      get :index
      expect(assigns(:posts)).to eq([ post2, post1 ])
    end
  end
end