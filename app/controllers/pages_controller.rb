class PagesController < ApplicationController

  def index
    @all_levels = Level.get_all_levels
    @degree_subjects = TutorProfile.all.pluck(:degree_subject)
    @teaching_subjects = TutorProfile.all.pluck(:teaching_subject)
    @teaching_subject_2 = TutorProfile.all.pluck(:teaching_subject_2)
    @teaching_subject_3 = TutorProfile.all.pluck(:teaching_subject_3)
    @all_tutors = TeachingSubject.get_all_teaching_subjects
    @all_tutors.uniq!
    @tutor_profiles = TutorProfile.all.paginate(:page => params[:page], :per_page => 20)
    @countries = Country.all
  end

  def about
  end

  def contact
  end

  def require_sign_in
  end
  
  def get_country_set_city
    if params[:country_name].present?
      country = Country.find_by(:name => params[:country_name])
    elsif params[:country_id].present?
      country = Country.find(params[:country_id])
    end
    cities = country.cities.pluck(:name)
    render :json => {cities: cities}
  end

end
