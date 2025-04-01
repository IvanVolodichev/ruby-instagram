# spec/models/like_spec.rb
require 'rails_helper'

RSpec.describe Like, type: :model do
  let(:user) { create(:user) }
  let(:post) { create(:post) }
  let(:like) { build(:like, post: post, user: user) }

  describe 'Validations' do
    context 'with valid attributes' do
      it 'is valid with user and post' do
        expect(like).to be_valid
      end
    end

    context 'with invalid attributes' do
      it 'is invalid without user' do
        like = build(:like, user: nil, post: post)
        expect(like).not_to be_valid
      end

      it 'is invalid without post' do
        like = build(:like, user: user, post: nil)
        expect(like).not_to be_valid
      end

      it 'prevents duplicate likes from same user on same post' do
        create(:like, user: user, post: post)
        duplicate_like = build(:like, user: user, post: post)
        expect(duplicate_like).not_to be_valid
      end
    end
  end
end