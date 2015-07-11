class TutorProfilesController < ApplicationController
  autocomplete :tutor_profile, :teaching_subject
  before_action :set_tutor_profile, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:new, :create, :update, :edit, :destroy]
  before_action :check_user, only: [:edit, :update, :destroy]



  def search
    @search_levels = params[:level]
    @search_subject = params[:search]
    @all_levels = Level.get_all_levels
    @filters = params.slice(:university)
    @all_tutors = TeachingSubject.get_all_teaching_subjects
    @countries = Country.all
    @search_university = params[:search_university]

    if params[:search].present? && params[:level].present?
      # both LEVEL and SUBJECT wise search
      @tutor_profiles = TutorProfile.get_all_subjects_with_levels(params[:search],params[:level])
    elsif params[:search].present?  && !params[:level].present?
      # only SUBJECT wise search
      @tutor_profiles = TutorProfile.get_matching_subject(params[:search])
    elsif params[:level].present? && !params[:search].present?
      # only LEVEL wise search
      @tutor_profiles = TutorProfile.get_matching_levels(params[:level])
    else
      @tutor_profiles = TutorProfile.where(:visibility => true).where(@filters)#.paginate(:page => params[:page], :per_page => 10)
    end

    if params[:search_university].present? && !@tutor_profiles.blank?
      tmp = []
      @tutor_profiles.each{|tp|(tmp << tp) if ( tp.university == params[:search_university] )}
      @tutor_profiles = tmp
    end

    if params[:search_city].present? && !@tutor_profiles.blank?
      tmp = []
      @tutor_profiles.each{|tp|(tmp << tp) if (tp.location_two==params[:search_city] || tp.location_city==params[:search_city])}
      @tutor_profiles = tmp
    elsif params[:search_country].present? && !@tutor_profiles.blank?
      tmp = []
      @tutor_profiles.each{|tp|(tmp << tp) if (tp.location==params[:search_country] || tp.country==params[:search_country])}
      @tutor_profiles = tmp
    end

    @tutor_profiles.paginate(:page => params[:page], :per_page => 10) if !@tutor_profiles.blank?

  end

  def autocomplete
    render json: TutorProfile.where("teaching_subject LIKE :teaching_subject",  {teaching_subject: "%#{params[:search]}%"}).where(@filters)
  end

  def index
   @search_levels = params[:level]
    @search_subject = params[:search]
    @all_levels = Level.get_all_levels
    @filters = params.slice(:university)
    @all_tutors = TeachingSubject.get_all_teaching_subjects
    @universities = University.all
    @countries = Country.all


    if params[:search].present? && params[:level].present?
      # both LEVEL and SUBJECT wise search
      @tutor_profiles = TutorProfile.get_all_subjects_with_levels(params[:search],params[:level])
    elsif params[:search].present?  && !params[:level].present?
      # only SUBJECT wise search
      @tutor_profiles = TutorProfile.get_matching_subject(params[:search])
    elsif params[:level].present? && !params[:search].present?
      # only LEVEL wise search
      @tutor_profiles = TutorProfile.get_matching_levels(params[:level])
    else
      @tutor_profiles = TutorProfile.where(:visibility => true).where(@filters).paginate(:page => params[:page], :per_page => 10)
    end
  end

  def show
    if params[:search_levels].present?
      @message_subject = " #{params[:search_subject.capitalize]} #{params[:search_levels].to_sentence}를 가르쳐 주실 선생님을 찾고 있습니다."
    else
      @message_subject = "#{params[:search_subject]}를 가르쳐 주실 선생님을 찾고 있습니다."
    end
    @similar_users = []
    if params[:similar_profiles].present? # check for similar user types to send message inquiry
      similar_tutors = TutorProfile.find(params[:similar_profiles])
      @similar_users = similar_tutors.collect { |tp| tp.user.id }
    end

    @user = @tutor_profile.user
    @blogs = @user.blogs
    @reviews = Review.where(tutor_profile_id: @tutor_profile.id).order("created_at DESC")
    if @reviews.blank?
      avg_rating = 0
    else
      @avg_rating = @reviews.average(:rating)#.round(2)
    end
  end

  def new
    if current_user.tutor_profile.nil?
      @tutor_profile = TutorProfile.new
    else
      flash[:error] = "프로필이 이미 있습니다."
      redirect_to root_path
    end
  end

  # GET /tutor_profiles/1/edit
  def edit
  end

  # POST /tutor_profiles
  # POST /tutor_profiles.json
  def create
    tutor_profile_params["degree_subject"].downcase!
    tutor_profile_params["teaching_subject"].downcase!
    tutor_profile_params["teaching_subject_2"].downcase!
    tutor_profile_params["teaching_subject_3"].downcase!
    @tutor_profile = TutorProfile.new(tutor_profile_params)
    @tutor_profile.user_id = current_user.id

    respond_to do |format|
      if @tutor_profile.save
        MessageMailer.send_notification_on_tutor_create(current_user.email,@tutor_profile)
        format.html { redirect_to @tutor_profile, notice: '프로필이 성공적으로 만들어졌습니다.' }
        format.json { render action: 'show', status: :created, location: @tutor_profile }
      else
        format.html { render action: 'new' }
        format.json { render json: @tutor_profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tutor_profiles/1
  # PATCH/PUT /tutor_profiles/1.json
  def update
    tutor_profile_params["degree_subject"].downcase!
    tutor_profile_params["teaching_subject"].downcase!
    tutor_profile_params["teaching_subject_2"].downcase!
    tutor_profile_params["teaching_subject_3"].downcase!
    respond_to do |format|
      if @tutor_profile.update(tutor_profile_params)
        format.html { redirect_to @tutor_profile, notice: '프로필이 성공적으로 업데이트 되었습니다.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @tutor_profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tutor_profiles/1
  # DELETE /tutor_profiles/1.json
  def destroy
    @tutor_profile.destroy
    respond_to do |format|
      format.html { redirect_to tutor_profiles_url }
      format.json { head :no_content }
    end
  end

  # review invitation link

  def invite_for_review
    if current_user.tutor_profile.present?
      @url = new_tutor_profile_review_url(current_user.tutor_profile)
    else
      flash[:error] = "선생님 프로필이 있어야 합니다."
      redirect_to :back
    end
  end

  def send_invitation_for_review
    if MessageMailer.send_invitation_for_review(params[:email],params[:first_name],params[:last_name],params[:message],params[:url],current_user.tutor_profile)
      flash[:notice] = "후기 요청을 보냈습니다."
      redirect_to root_path
    else
      redirect_to :back
    end
  end

  def send_user_specific_request_for_review
    @email = Tuition.find(params[:tuition_id]).user.email
    @url = new_tutor_profile_review_url(current_user.tutor_profile)
    if MessageMailer.send_user_specific_request_for_review(@email,@url,current_user.tutor_profile)
      flash[:notice] = "후기 요청을 보냈습니다."
    else
      flash[:error] = "후기 요청을 보낼수 없습니다. 이메일 주소를 한번 더 확인 해주십시요."
    end
    redirect_to :back
  end

  # /review invitation link

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_tutor_profile
    @tutor_profile = TutorProfile.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def tutor_profile_params
    params.require(:tutor_profile).permit(:user_id, :university, :degree_subject, :teaching_subject, :teaching_subject_2, :teaching_subject_3, :location, :about_myself, :tutoring_approach, :teaching_experience, :extracurricular_interests, :image, :tutor_profile_id, :subject_level, :hourly_rate, :hours)
  end

  def check_user
    if current_user != @tutor_profile.user
      redirect_to root_url, alert: "죄송합니다. 이 프로필은 다른 분것입니다."
    end
  end
end