ActiveAdmin.register TutorProfile do

  menu :priority => 4

  permit_params :utf8, :authenticity_token, :commit, :university, :location, :location_city, :country, :location_two, :image_file_name, :image_content_type, :image_file_size, :image_updated_at, :image

  actions :all, :except => [:new]

  index do
    column :id
    column :user
    column :degree_subject do |obj| 
      obj.tutor_degree_subjects.first.degree_subject if !(obj.tutor_degree_subjects.blank?)
    end
    column :university
    column :teaching_subjectdo do |obj|
      obj.tutor_teaching_subjects.first.teaching_subject if !(obj.tutor_teaching_subjects.blank?)
    end
    column :created_at
    actions
  end

  form do |f|
    f.inputs "Tutor Profile Details" do

      div do
        "&nbsp;&nbsp;
         This profile is having current university : <b> #{f.object.university} </b>
         <br>&nbsp;&nbsp;
         Select any from below drop down to change it.
        ".html_safe
      end
      f.input :university, as: :select, :collection => University.pluck(:name)

      div style: "height: 1px; background: #333333; margin: 10px 0;"

      div do
        "&nbsp;&nbsp;
         This profile is having current country 1 - city 1 as : <b> #{f.object.location} - #{f.object.location_city} </b>
         <br>&nbsp;&nbsp;
         Select any from below drop down to change it.
        ".html_safe
      end
      f.input :location, as: :select, :collection => Country.pluck(:name), label: "Country 1"
      f.input :location_city, as: :select, :collection => City.pluck(:name), label: "City 1"

      div style: "height: 1px; background: #333333; margin: 10px 0;"

      div do
        "&nbsp;&nbsp;
         This profile is having current country 2 - city 2 as : <b> #{f.object.country} - #{f.object.location_two} </b>
         <br>&nbsp;&nbsp;
         Select any from below drop down to change it.
        ".html_safe
      end
      f.input :country, as: :select, :collection => Country.pluck(:name), label: "Country 2"
      f.input :location_two, as: :select, :collection => City.pluck(:name), label: "City 2"
      f.input :image
    end
    f.actions
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
