# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }
  let(:post) { create(:post, user: user) }
  let(:like) { build(:like, post: post, user: user) }

  describe 'Validations' do
    it 'is valid with valid attributes' do
      expect(user).to be_valid
    end

    it 'is invalid without username' do
      user.username = nil
      expect(user).not_to be_valid
    end

    it 'is invalid with duplicate username' do
      create(:user, username: 'testuser')
      user2 = build(:user, username: 'testuser')
      expect(user2).not_to be_valid
    end

    it 'is invalid with username shorter than 3 characters' do
      user.username = 'ab'
      expect(user).not_to be_valid
    end

    it 'is invalid with username longer than 75 characters' do
      user.username = 'a' * 76
      expect(user).not_to be_valid
    end

		it 'is valid with correct avatar type' do
      user.avatar.attach(
        io: File.open(Rails.root.join('spec', 'fixtures', 'test_image1.jpg')),
        filename: 'test_image1.jpg',
        content_type: 'test_image1.jpg'
      )
      expect(user).to be_valid
    end

		it 'is invalid with incorrect avatar type' do
      user.avatar.attach(
        io: File.open(Rails.root.join('spec', 'fixtures', 'text.txt')),
        filename: 'text.txt',
        content_type: 'txt'
      )
      expect(user).not_to be_valid
    end

		context 'when user has liked the post' do
      before do
        create(:like, user: user, post: post)
      end

      it 'returns true' do
        expect(user.liked?(post)).to be true
      end
    end

    context 'when user has not liked the post' do
      it 'returns false' do
        expect(user.liked?(post)).to be false
      end
    end
  end
end