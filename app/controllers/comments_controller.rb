class CommentsController < ApplicationController
  before_action :set_comment, :check_owner, only: [ :destroy ]

  def create
    puts params
    @comment  = current_user.comments.new(comment_params)

    if @comment.save
      redirect_to post_path(id: comment_params[:post_id]), notice: "Комментарий успешно добавлен"
    else
      redirect_to post_path(id: comment_params[:post_id]), alert: "Произошла ошибка при добавлении комментария"
    end
  end

  def destroy
    if @comment.destroy
      redirect_to post_path(id: comment_params[:post_id]), notice: "Комментарий был удалён"
    else
      redirect_to post_path(id: comment_params[:post_id]), alert: "Произошла ошибка при удалении комментария"
    end
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def check_owner
    if @comment.user_id != current_user.id
      flash[:error] = "У вас нет прав на удаление этого коментария"
      redirect_to @comment.post
    end
  end

  def comment_params
    params.permit(:text, :post_id)
  end
end
