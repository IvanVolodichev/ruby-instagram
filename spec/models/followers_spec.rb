# spec/models/follower_spec.rb
require 'rails_helper'

RSpec.describe Follower, type: :model do
  let(:follower_user) { create(:user) }
  let(:following_user) { create(:user) }
  let(:valid_follow) { build(:follow_relationship, follower: follower_user, following: following_user) }

  describe 'Validations' do
    context 'with valid attributes' do
      it 'is valid with unique follower and following' do
        expect(valid_follow).to be_valid
      end
    end

    context 'with invalid attributes' do
      it 'is invalid without follower' do
        follow = build(:follow_relationship, follower: nil, following: following_user)
        expect(follow).not_to be_valid
      end

      it 'is invalid without following' do
        follow = build(:follow_relationship, follower: follower_user, following: nil)
        expect(follow).not_to be_valid
      end

      it 'prevents duplicate follows' do
        create(:follow_relationship, follower: follower_user, following: following_user)
        duplicate_follow = build(:follow_relationship, follower: follower_user, following: following_user)
        expect(duplicate_follow).not_to be_valid
      end

      it 'allows user to follow different users' do
        create(:follow_relationship, follower: follower_user, following: following_user)
        new_follow = build(:follow_relationship, follower: follower_user, following: create(:user))
        expect(new_follow).to be_valid
      end

      it 'allows different users to follow same user' do
        create(:follow_relationship, follower: follower_user, following: following_user)
        new_follow = build(:follow_relationship, follower: create(:user), following: following_user)
        expect(new_follow).to be_valid
      end

      it 'prevents user from following themselves' do
        self_follow = build(:follow_relationship, follower: follower_user, following: follower_user)
        expect(self_follow).not_to be_valid
      end
    end
  end
end