class NewTutorProfilesController < Wicked::WizardController

  before_action :set_levels
  before_action :check_availability
  before_action :authenticate_user!

  steps :step1, :step2, :step3, :finish, :method => :post

  def show
    if params[:id]=="finish"

    else
      @all_degree_subjects = DegreeSubject.get_all_degree_subjects
      @tutor_profile = current_user.tutor_profile || TutorProfile.find_or_create_by(:user_id => current_user.id)
      if params[:id]=="step1"
        if (@tutor_profile.country.present? rescue false)
          @cities = Country.find_by(:name => @tutor_profile.country).cities.pluck(:name) rescue []
        else
          @cities = []
        end
        @countries = Country.all-[Country.host_location]
      end
      if params[:id]=="step2"
        @tutor_degree_subject_levels = @tutor_profile.tutor_degree_subjects.first.degree_subject_levels.pluck(:level)
        @ttsl0 = @tutor_profile.tutor_teaching_subjects[0].teaching_subject_levels.pluck(:level) rescue []
        @ttsl1 = @tutor_profile.tutor_teaching_subjects[1].teaching_subject_levels.pluck(:level) rescue []
        @ttsl2 = @tutor_profile.tutor_teaching_subjects[2].teaching_subject_levels.pluck(:level) rescue []
      end
    end
    render_wizard
  end

  def update_tutor_profile
    case params[:user_step]
      when "step1"
        step_1_method
      when "step2"
        step_2_method
      when "step3"
        step_3_method
      when "finish"
    end
  end

  def step_1_method
    # raise params.inspect
    # Save User's tutor profile
    @tutor_profile = current_user.tutor_profile || TutorProfile.find_or_initialize_by(:user_id => current_user.id)
    @tutor_profile.country = params[:country]
    @tutor_profile.location_two = params[:location_two]
    @tutor_profile.location_city = params[:location_city]
    @tutor_profile.update_attributes(step_1_params)


    # Save / update degree subject of tutor_profile
    if @tutor_profile.tutor_degree_subjects.blank?
      degree_subject = @tutor_profile.tutor_degree_subjects.new
    else
      degree_subject = @tutor_profile.tutor_degree_subjects.first
    end

    # Saving the new degree subject
    unless params[:degree_subject].blank?
      degree_subject.degree_subject = params[:degree_subject]
      degree_subject.save
    end

    # redirect to step 2
    redirect_to wizard_path(:step2)
    # redirect_to render "croppper"
  end

  # def cropper
  #   raise params.inspect
  #   redirect_to wizard_path(:step2)
  # end


  def step_2_method
    # raise params.inspect
    @tutor_profile = current_user.tutor_profile
    if params[:tutor_profile].present?
      if params[:tutor_profile][:image].present?
        @tutor_profile.image = params[:tutor_profile][:image]
      end
    end
    @tutor_profile.save

    ## Saving or updating the degree subject levels
    input_degree_subject_levels = params[:degree_subject_levels]
    tutor_degree_subject_levels = @tutor_profile.tutor_degree_subjects.first.degree_subject_levels

    if input_degree_subject_levels
      input_degree_subject_levels.each do |idsl|
        unless tutor_degree_subject_levels.pluck(:level).include?(idsl)
          @tutor_profile.tutor_degree_subjects.first.degree_subject_levels.create(:level => idsl)
        end
      end
      @tutor_profile.tutor_degree_subjects.first.degree_subject_levels.each do |dsl|
        unless input_degree_subject_levels.include?(dsl.level)
          dsl.destroy
        end
      end
    end

    ## Saving and updating teaching subjects
    tutor_teaching_subjects = @tutor_profile.tutor_teaching_subjects
    tutor_teaching_subjects.each do |tts|
      unless params[:teaching_subject].include?(tts.teaching_subject)
        tts.destroy
      end
    end
    params[:teaching_subject].each do |its|
      unless tutor_teaching_subjects.pluck(:teaching_subject).include?(its)
        if !(its.blank?)
          tutor_teaching_subjects.create(:teaching_subject => its)
        end
      end
    end

    ## Saving and updating teaching subject levels
    tutor_teaching_subjects = @tutor_profile.tutor_teaching_subjects
    params[:teaching_subject].each_with_index do |ts,index|
      # raise params.inspect
      if !(ts.blank?)
        tts = tutor_teaching_subjects.find_by(:teaching_subject => ts)
        tts_levels = tts.teaching_subject_levels
        input_levels = params[:teaching_sub][index.to_s] rescue []
        tts_levels.each do |tl|
          unless (input_levels.include?(tl.level) rescue false)
            tl.destroy
          end
        end
      end
    end

    params[:teaching_subject].each_with_index do |ts,index|
      if ts
        tts = tutor_teaching_subjects.find_by(:teaching_subject => ts)
        if tts
          tts_levels = tts.teaching_subject_levels
          input_levels = params[:teaching_sub][index.to_s] rescue []
          unless input_levels.blank?
            input_levels.each do |il|
              unless tts_levels.pluck(:level).include?(il)
                tts_levels.create(:level => il)
              end
            end
          end
        end
      end
    end

    redirect_to wizard_path(:step3)
  end


  def step_3_method
    @tutor_profile = current_user.tutor_profile
    if step_3_params
      @tutor_profile.update_attributes(step_3_params)
      @tutor_profile.reprocess_avatar
    end
    MessageMailer.send_notification_on_tutor_create(current_user.email,@tutor_profile)
    
    redirect_to wizard_path(:finish)
  end



  def final_step
    raise params.inspect
  end



  def check_availability
    # raise current_user.tutor_profile.tutor_degree_subjects.inspect
    case params[:id]
      when "step2"
        if (current_user.tutor_profile.tutor_degree_subjects.blank? rescue true)
          flash[:error] = "Please fill in all the required fields"
          redirect_to wizard_path(:step1)
        end
      when "step3"
        if !(current_user.tutor_profile.tutor_degree_subjects.first.degree_subject_levels.length>0)
          flash[:error] = "Please select at least one degree subject level"
          redirect_to wizard_path(:step2)
        else
          if current_user.tutor_profile.tutor_teaching_subjects.length>0
            unless current_user.tutor_profile.tutor_teaching_subjects.collect{|tts| tts.teaching_subject_levels.pluck(:level) }.flatten.length>0
              flash[:error] = "Please select at least one level in any of the teaching subjects"
              redirect_to wizard_path(:step2)
            end
          else
            flash[:error] = "Please select at least one teaching subject"
            redirect_to wizard_path(:step2)
          end
        end        
      
        if (current_user.tutor_profile.tutor_degree_subjects.blank? rescue true)
          flash[:error] = "모든 항목을 적어주세요."
          redirect_to wizard_path(:step1)
        end
    end
  end



  def set_levels
    @new_exam_preparation_levels_object = TeachingSubjectLevel.new
    @university_admission_levels = Level.university_admission_levels
    @exam_preparation_levels = Level.exam_preparation_levels
    @all_teaching_subjects = TeachingSubject.get_all_teaching_subjects
  end

  private
  def step_1_params
    params.require(:tutor_profile).permit(:university, :hourly_rate, :location, :location_two, :contact_num, :location_two, :country, :detailed_location, :contact_details, :graduate_school, :image2, :detailed_location_two)
  end

  def step_2_params
    raise params.inspect
    params.require(:tutor_profile).permit(:image)
  end

  def step_3_params
    params.require(:tutor_profile).permit(:about_myself, :teaching_experience, :tutoring_approach, :extracurricular_interests, :crop_x, :crop_y, :crop_h, :crop_w)
  end

end