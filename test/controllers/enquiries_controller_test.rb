require 'test_helper'

class EnquiriesControllerTest < ActionController::TestCase
  setup do
    @enquiry = enquiries(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:enquiries)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create enquiry" do
    assert_difference('Enquiry.count') do
      post :create, enquiry: { duration: @enquiry.duration, level: @enquiry.level, location: @enquiry.location, note: @enquiry.note, start_date: @enquiry.start_date, subject: @enquiry.subject, tuition_fee: @enquiry.tuition_fee, tutor_availablity: @enquiry.tutor_availablity, tutorial_request: @enquiry.tutorial_request }
    end

    assert_redirected_to enquiry_path(assigns(:enquiry))
  end

  test "should show enquiry" do
    get :show, id: @enquiry
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @enquiry
    assert_response :success
  end

  test "should update enquiry" do
    patch :update, id: @enquiry, enquiry: { duration: @enquiry.duration, level: @enquiry.level, location: @enquiry.location, note: @enquiry.note, start_date: @enquiry.start_date, subject: @enquiry.subject, tuition_fee: @enquiry.tuition_fee, tutor_availablity: @enquiry.tutor_availablity, tutorial_request: @enquiry.tutorial_request }
    assert_redirected_to enquiry_path(assigns(:enquiry))
  end

  test "should destroy enquiry" do
    assert_difference('Enquiry.count', -1) do
      delete :destroy, id: @enquiry
    end

    assert_redirected_to enquiries_path
  end
end
