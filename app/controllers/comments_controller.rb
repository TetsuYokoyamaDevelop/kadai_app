class CommentsController < ApplicationController
  before_action :require_login, only: [:create, :destroy]
  before_action :set_comment, only: [:create, :destroy]

  def index
    @comments = Comment.all
  end

  def new
    @user = current_user
    @comment = Comment.new
  end

  def create
    @user = current_user
    @comment = Comment.where(micropost_id: current_micropost.id).new(comment_params)

    if @comment.save
      flash[:success] = "Comment created!"
      redirect_to comments_path
    else
      render 'new'
    end
  end

  def destroy
    if @comment.user_id == current_user.id
      @comment.destroy
      redirect_to comments_path
    else
      flash[:alert] = "You cannot destroy this comment"
      render 'index'
    end
  end

  private

    def set_comment
      @comment = Comment.find(params[:id])
    end

    def comment_params
      params.require(:comment).permit(:replyment, :user_id)
    end

end
