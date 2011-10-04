require 'test_helper'
include Devise::TestHelpers

class PackagesControllerTest < ActionController::TestCase
  setup do
    @user = FactoryGirl.create(:user)
    sign_in @user
    @server = FactoryGirl.create(:server, :user => @user)
    @package = FactoryGirl.create(:package, :server => @server)
    @user2 = FactoryGirl.create(:user) # test non-authed users
    @server2 = FactoryGirl.create(:server, :user => @user2)
  end

  test "should get index" do
    get :index, :server_id => @server.to_param
    assert_response :success
    assert_not_nil assigns(:packages)
  end

  test "should get new" do
    get :new, :server_id => @server.to_param
    assert_response :success
  end

  test "should create package" do
    assert_difference('Package.count') do
      post :create, :package => @package.attributes, :server_id => @server.to_param
    end

    assert_redirected_to server_url(assigns(:package).server)
  end
  
  test "users shouldn't be able to add packages to other servers" do
    post :create, :package => FactoryGirl.create(:package), :server_id => @server2.to_param
    assert_redirected_to user_url(assigns(:user))
  end

  test "should show package" do
    get :show, :id => @package.to_param, :server_id => @server.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @package.to_param, :server_id => @server.to_param
    assert_response :success
  end

  test "should update package" do
    put :update, :id => @package.to_param, :package => @package.attributes, :server_id => @server.to_param
    assert_redirected_to server_path(assigns(:package).server)
  end

  test "should destroy package" do
    assert_difference('Package.count', -1) do
      delete :destroy, :id => @package.to_param, :server_id => @server.to_param
    end

    assert_redirected_to server_packages_path
  end
end
