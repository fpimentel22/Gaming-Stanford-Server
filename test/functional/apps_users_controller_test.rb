require 'test_helper'

class AppsUsersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:apps_users)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create apps_users" do
    assert_difference('AppsUsers.count') do
      post :create, :apps_users => { }
    end

    assert_redirected_to apps_users_path(assigns(:apps_users))
  end

  test "should show apps_users" do
    get :show, :id => apps_users(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => apps_users(:one).to_param
    assert_response :success
  end

  test "should update apps_users" do
    put :update, :id => apps_users(:one).to_param, :apps_users => { }
    assert_redirected_to apps_users_path(assigns(:apps_users))
  end

  test "should destroy apps_users" do
    assert_difference('AppsUsers.count', -1) do
      delete :destroy, :id => apps_users(:one).to_param
    end

    assert_redirected_to apps_users_path
  end
end
