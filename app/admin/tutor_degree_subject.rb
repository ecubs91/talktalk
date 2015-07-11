ActiveAdmin.register TutorDegreeSubject do

  menu :priority => 5

  permit_params :utf8, :authenticity_token, :commit, :tutor_profile_id, :degree_subject

  member_action :new_degree_subject_level, :method => :get do
    redirect_to :action => :new_degree_subject_level
  end
  member_action :create_degree_subject_level, :method => :post do
    redirect_to :action => :create_degree_subject_level
  end

  controller do
    def new_degree_subject_level
      @levels = Level.university_admission_levels
    end
    def create_degree_subject_level
      @tds = TutorDegreeSubject.find(params[:id])
      params[:levels].each do |level|
        @tds.degree_subject_levels.build(:level => level).save
      end
      redirect_to admin_tutor_degree_subjects_path
    end
  end

  form do |f|
    f.inputs "Details" do
      f.input :tutor_profile_id, :as => :select, :collection => User.all.collect{|u| u if u.tutor_profile.present?}.compact.collect{|u| ["#{u.id}) #{u.email}",u.tutor_profile.id] }, :label => "Select User's Email"
      f.input :degree_subject, :as => :select, :collection => DegreeSubject.get_all_degree_subjects.sort
    end
    f.actions
  end

  index do
    column :id
    column "User" do |tp|
      tp.tutor_profile.user.email rescue "User not found"
    end
    column :tutor_profile
    column :degree_subject
    column "Add Levels" do |tp|
      link_to "add degree levels", new_degree_subject_level_admin_tutor_degree_subject_path(:id => tp.id)
    end
    column "levels" do |tp|
      tp.degree_subject_levels.pluck("level").join(", ")
    end
    actions
  end



  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if resource.something?
  #   permitted
  # end


end
