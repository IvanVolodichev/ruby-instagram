class LikesController < ApplicationController
    def create
        @like = current_user.likes.new(like_params)
        if @like.save
          redirect_to root_path
        else
          puts "Something went wrong"
        end
    end

    def destroy
        @like = Like.find(params[:id])
        if @like.destroy
          redirect_to root_path
        else
          puts "Something went wrong"
        end
    end

    private
    def like_params
        params.permit(:post_id)
    end
end
