require 'test_helper'

class ObjectsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:objects)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create objects" do
    assert_difference('Objects.count') do
      post :create, :objects => { }
    end

    assert_redirected_to objects_path(assigns(:objects))
  end

  test "should show objects" do
    get :show, :id => objects(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => objects(:one).to_param
    assert_response :success
  end

  test "should update objects" do
    put :update, :id => objects(:one).to_param, :objects => { }
    assert_redirected_to objects_path(assigns(:objects))
  end

  test "should destroy objects" do
    assert_difference('Objects.count', -1) do
      delete :destroy, :id => objects(:one).to_param
    end

    assert_redirected_to objects_path
  end
end
