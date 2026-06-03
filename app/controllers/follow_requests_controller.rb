class FollowRequestsController < ApplicationController
  def create
    receiver = User.find(params[:receiver_id])
    request = current_user.sent_follow_requests.build(receiver: receiver, status: "pending")
  
    if request.save
      redirect_to users_path, notice: "Follow request sent."
    else
      redirect_to users_path, alert: request.errors.full_messages.to_sentence
    end
  end

  def update
    request = current_user.received_follow_requests.find(params[:id])
    request.update(status: "accepted")

    redirect_to users_path, notice: "Follow request accepted."
  end

  def destroy
    request = FollowRequest.find(params[:id])
    if request.sender == current_user || request.receiver == current_user
      request.destroy
      redirect_to users_path, notice: "Follow request deleted."
    else
      redirect_to users_path, alert: "You are not authorized to delete this follow request."
    end
  end
end