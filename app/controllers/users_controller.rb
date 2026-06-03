class UsersController < ApplicationController
  def index
    @users = User.includes(:profile).where.not(id: current_user.id)
  end

  def show
    @user = User.includes(:posts, :profile).find(params[:id])
  end
end
