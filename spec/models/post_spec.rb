# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:user) { create(:user) }
  let(:post) { create(:post) }

  describe 'Validations' do
    context "with valid attributes" do
      it 'is valid with valid attributes' do
        expect(post).to be_valid
      end
    end

    context "with invalid attributes" do
      it 'is invalid without description' do
        post.description = nil
        expect(post).not_to be_valid
      end
  
      it 'is invalid without images' do
        post.images = nil
        expect(post).not_to be_valid
      end

      it 'is invalid with large images' do
        post.images.attach(
          io: File.open(Rails.root.join('spec', 'fixtures', 'large_image.jpg')),
          filename: 'large_image.jpg',
          content_type: 'image/jpeg'
        )
        expect(post).not_to be_valid
      end

      it 'is invalid with text file' do
        post.images.attach(
          io: File.open(Rails.root.join('spec', 'fixtures', 'text.txt')),
          filename: 'text.txt',
          content_type: 'txt'
        )
        expect(post).not_to be_valid
      end
    end
    
    

    
  end
end
