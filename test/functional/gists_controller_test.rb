require 'test_helper'

class GistsControllerTest < ActionController::TestCase
  setup do
    @gist = gists(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:gists)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create gist" do
    assert_difference('Gist.count') do
      post :create, :gist => @gist.attributes
    end

    assert_redirected_to gist_path(assigns(:gist))
  end

  test "should show gist" do
    get :show, :id => @gist.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @gist.to_param
    assert_response :success
  end

  test "should update gist" do
    put :update, :id => @gist.to_param, :gist => @gist.attributes
    assert_redirected_to gist_path(assigns(:gist))
  end

  test "should destroy gist" do
    assert_difference('Gist.count', -1) do
      delete :destroy, :id => @gist.to_param
    end

    assert_redirected_to gists_path
  end
end
