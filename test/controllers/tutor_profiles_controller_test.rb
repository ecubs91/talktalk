require 'test_helper'

class TutorProfilesControllerTest < ActionController::TestCase
  setup do
    @tutor_profile = tutor_profiles(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tutor_profiles)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tutor_profile" do
    assert_difference('TutorProfile.count') do
      post :create, tutor_profile: { about_myself: @tutor_profile.about_myself, degree_subject: @tutor_profile.degree_subject, extracurricular_interests: @tutor_profile.extracurricular_interests, location: @tutor_profile.location, teaching_experience: @tutor_profile.teaching_experience, teaching_subject: @tutor_profile.teaching_subject, tutoring_approach: @tutor_profile.tutoring_approach, university: @tutor_profile.university, user_id: @tutor_profile.user_id }
    end

    assert_redirected_to tutor_profile_path(assigns(:tutor_profile))
  end

  test "should show tutor_profile" do
    get :show, id: @tutor_profile
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tutor_profile
    assert_response :success
  end

  test "should update tutor_profile" do
    patch :update, id: @tutor_profile, tutor_profile: { about_myself: @tutor_profile.about_myself, degree_subject: @tutor_profile.degree_subject, extracurricular_interests: @tutor_profile.extracurricular_interests, location: @tutor_profile.location, teaching_experience: @tutor_profile.teaching_experience, teaching_subject: @tutor_profile.teaching_subject, tutoring_approach: @tutor_profile.tutoring_approach, university: @tutor_profile.university, user_id: @tutor_profile.user_id }
    assert_redirected_to tutor_profile_path(assigns(:tutor_profile))
  end

  test "should destroy tutor_profile" do
    assert_difference('TutorProfile.count', -1) do
      delete :destroy, id: @tutor_profile
    end

    assert_redirected_to tutor_profiles_path
  end
end
