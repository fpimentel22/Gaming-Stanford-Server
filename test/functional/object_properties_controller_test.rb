require 'test_helper'

class ObjectPropertiesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:object_properties)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create object_properties" do
    assert_difference('ObjectProperties.count') do
      post :create, :object_properties => { }
    end

    assert_redirected_to object_properties_path(assigns(:object_properties))
  end

  test "should show object_properties" do
    get :show, :id => object_properties(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => object_properties(:one).to_param
    assert_response :success
  end

  test "should update object_properties" do
    put :update, :id => object_properties(:one).to_param, :object_properties => { }
    assert_redirected_to object_properties_path(assigns(:object_properties))
  end

  test "should destroy object_properties" do
    assert_difference('ObjectProperties.count', -1) do
      delete :destroy, :id => object_properties(:one).to_param
    end

    assert_redirected_to object_properties_path
  end
end
