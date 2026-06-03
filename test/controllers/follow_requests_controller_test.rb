require "test_helper"

class FollowRequestsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get follow_requests_create_url
    assert_response :success
  end

  test "should get update" do
    get follow_requests_update_url
    assert_response :success
  end

  test "should get destroy" do
    get follow_requests_destroy_url
    assert_response :success
  end
end
