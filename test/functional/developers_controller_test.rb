require 'test_helper'

class DevelopersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:developers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create developers" do
    assert_difference('Developers.count') do
      post :create, :developers => { }
    end

    assert_redirected_to developers_path(assigns(:developers))
  end

  test "should show developers" do
    get :show, :id => developers(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => developers(:one).to_param
    assert_response :success
  end

  test "should update developers" do
    put :update, :id => developers(:one).to_param, :developers => { }
    assert_redirected_to developers_path(assigns(:developers))
  end

  test "should destroy developers" do
    assert_difference('Developers.count', -1) do
      delete :destroy, :id => developers(:one).to_param
    end

    assert_redirected_to developers_path
  end
end
