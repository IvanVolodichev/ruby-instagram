# frozen_string_literal: true

class Posts::CardComponent < ViewComponent::Base
    def initialize(post)
      @post = post
    end
end
