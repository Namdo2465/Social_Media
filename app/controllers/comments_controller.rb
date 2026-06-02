class CommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user
    
    if @comment.save
      redirect_to root_path, notice: "Comment added."
    else
      redirect_to root_path, alert: "Failed to add comment."
    end
  end

  def destroy
    @comment = current_user.comments.find(params[:id])
    @comment.destroy

    redirect_to root_path, notice: "Comment deleted."
  end

  private
  def comment_params
    params.require(:comment).permit(:content)
  end
end
