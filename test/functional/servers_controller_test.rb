require 'test_helper'
include Devise::TestHelpers

class ServersControllerTest < ActionController::TestCase
  setup do
    @user = FactoryGirl.create(:user)
    sign_in @user
    @server = FactoryGirl.create(:server, :user => @user)
  end

  test "should get index" do
    get :index, :user_id => @user.to_param
    assert_response :success
    assert_not_nil assigns(:servers)
  end

  test "should get new" do
    get :new, :user_id => @user.to_param
    assert_response :success
  end

  test "should create server" do
    assert_difference('Server.count') do
      post :create, :server => @server.attributes, :user_id => @user.to_param
    end

    assert_redirected_to server_path(assigns(:server))
  end

  test "should show server" do
    get :show, :id => @server.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @server.to_param
    assert_response :success
  end

  test "should update server" do
    put :update, :id => @server.to_param, :server => @server.attributes
    assert_redirected_to server_path(assigns(:server))
  end

  test "should destroy server" do
    assert_difference('Server.count', -1) do
      delete :destroy, :id => @server.to_param
    end

    assert_redirected_to servers_url
  end
end
