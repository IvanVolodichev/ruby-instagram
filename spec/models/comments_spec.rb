require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:user) { create(:user) }
  let(:post) { create(:post) }
  let(:comment) { create(:comment, post: post, user: user) }

  describe 'Validations' do
    it "valid comments" do
        expect(comment).to be_valid 
    end

    context "invalid comments" do
			it "without text" do
				comment.text = nil
        expect(comment).not_to be_valid 
    	end

			it "without owner" do
				comment.user_id = nil
        expect(comment).not_to be_valid 
    	end

			it "without target post" do
				comment.post_id = nil
        expect(comment).not_to be_valid
    	end
		end
  end
end