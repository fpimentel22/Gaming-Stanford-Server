require 'test_helper'

class GroupsUsersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:groups_users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create groups_users" do
    assert_difference('GroupsUsers.count') do
      post :create, :groups_users => { }
    end

    assert_redirected_to groups_users_path(assigns(:groups_users))
  end

  test "should show groups_users" do
    get :show, :id => groups_users(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => groups_users(:one).to_param
    assert_response :success
  end

  test "should update groups_users" do
    put :update, :id => groups_users(:one).to_param, :groups_users => { }
    assert_redirected_to groups_users_path(assigns(:groups_users))
  end

  test "should destroy groups_users" do
    assert_difference('GroupsUsers.count', -1) do
      delete :destroy, :id => groups_users(:one).to_param
    end

    assert_redirected_to groups_users_path
  end
end
