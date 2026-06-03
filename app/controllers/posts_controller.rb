class PostsController < ApplicationController
  def index
    @post = current_user.posts.build
  
    user_ids = current_user.following.pluck(:id) + [current_user.id]
  
    @posts = Post
             .includes(:user, :comments, :likes)
             .where(user_id: user_ids)
             .order(created_at: :desc)
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to root_path, notice: "Post created."
    else
      @posts = Post.includes(:user).order(created_at: :desc)
      render :index, status: :unprocessable_entity
    end
  end

  def destroy
    @post = current_user.posts.find(params[:id])
    @post.destroy
    redirect_to root_path, notice: "Post deleted."
  end

  private
  def post_params
    params.require(:post).permit(:content)
  end
end
