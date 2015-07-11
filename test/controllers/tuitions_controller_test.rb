require 'test_helper'

class TuitionsControllerTest < ActionController::TestCase
  setup do
    @tuition = tuitions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tuitions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tuition" do
    assert_difference('Tuition.count') do
      post :create, tuition: { city: @tuition.city, hours: @tuition.hours, note: @tuition.note, tutor_profile_id: @tuition.tutor_profile_id, user_id: @tuition.user_id }
    end

    assert_redirected_to tuition_path(assigns(:tuition))
  end

  test "should show tuition" do
    get :show, id: @tuition
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tuition
    assert_response :success
  end

  test "should update tuition" do
    patch :update, id: @tuition, tuition: { city: @tuition.city, hours: @tuition.hours, note: @tuition.note, tutor_profile_id: @tuition.tutor_profile_id, user_id: @tuition.user_id }
    assert_redirected_to tuition_path(assigns(:tuition))
  end

  test "should destroy tuition" do
    assert_difference('Tuition.count', -1) do
      delete :destroy, id: @tuition
    end

    assert_redirected_to tuitions_path
  end
end
