require 'test_helper'

class TutorshipsControllerTest < ActionController::TestCase
  setup do
    @tutorship = tutorships(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tutorships)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tutorship" do
    assert_difference('Tutorship.count') do
      post :create, tutorship: { accepted: @tutorship.accepted, duration: @tutorship.duration, starting_date: @tutorship.starting_date, student_id: @tutorship.student_id, subject_id: @tutorship.subject_id, tutor_id: @tutorship.tutor_id }
    end

    assert_redirected_to tutorship_path(assigns(:tutorship))
  end

  test "should show tutorship" do
    get :show, id: @tutorship
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tutorship
    assert_response :success
  end

  test "should update tutorship" do
    patch :update, id: @tutorship, tutorship: { accepted: @tutorship.accepted, duration: @tutorship.duration, starting_date: @tutorship.starting_date, student_id: @tutorship.student_id, subject_id: @tutorship.subject_id, tutor_id: @tutorship.tutor_id }
    assert_redirected_to tutorship_path(assigns(:tutorship))
  end

  test "should destroy tutorship" do
    assert_difference('Tutorship.count', -1) do
      delete :destroy, id: @tutorship
    end

    assert_redirected_to tutorships_path
  end
end
