require 'test_helper'

class ScoreBoardsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:score_boards)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create score_board" do
    assert_difference('ScoreBoard.count') do
      post :create, :score_board => { }
    end

    assert_redirected_to score_board_path(assigns(:score_board))
  end

  test "should show score_board" do
    get :show, :id => score_boards(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => score_boards(:one).to_param
    assert_response :success
  end

  test "should update score_board" do
    put :update, :id => score_boards(:one).to_param, :score_board => { }
    assert_redirected_to score_board_path(assigns(:score_board))
  end

  test "should destroy score_board" do
    assert_difference('ScoreBoard.count', -1) do
      delete :destroy, :id => score_boards(:one).to_param
    end

    assert_redirected_to score_boards_path
  end
end
