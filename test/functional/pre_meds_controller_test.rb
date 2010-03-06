require 'test_helper'

class PreMedsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:pre_meds)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create pre_med" do
    assert_difference('PreMed.count') do
      post :create, :pre_med => { }
    end

    assert_redirected_to pre_med_path(assigns(:pre_med))
  end

  test "should show pre_med" do
    get :show, :id => pre_meds(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => pre_meds(:one).to_param
    assert_response :success
  end

  test "should update pre_med" do
    put :update, :id => pre_meds(:one).to_param, :pre_med => { }
    assert_redirected_to pre_med_path(assigns(:pre_med))
  end

  test "should destroy pre_med" do
    assert_difference('PreMed.count', -1) do
      delete :destroy, :id => pre_meds(:one).to_param
    end

    assert_redirected_to pre_meds_path
  end
end
