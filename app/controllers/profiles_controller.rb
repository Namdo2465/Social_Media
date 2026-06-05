class ProfilesController < ApplicationController
  def edit
    @profile = current_user.profile
  end

  def update
    @profile = current_user.profile

    if @profile.update(profile_params)
      redirect_to root_path, notice: "Profile updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    params.require(:profile).permit(:name, :bio, :avatar)
  end
end
