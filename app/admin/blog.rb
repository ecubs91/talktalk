ActiveAdmin.register Blog do

  # actions :all, :except => [:new,:destroy]
   permit_params :utf8, :authenticity_token, :commit, :id, :title, :content, :description, :education, :image, :user_id


  index do
    column :id
    column :title
    column :education
    column :image do |x|
      if x.image.present?
        image_tag x.image.url, style: "max-height: 100px; max-width: 100px;"
      else
        "No Image Found"
      end
    end
    actions
  end

  form :html => { :enctype => "multipart/form-data" } do |f|
    f.inputs "Details" do
      f.input :title
      f.input :description
      f.input :content
      f.input :education
      f.input :image
      f.input :user_id, as: :select, collection: TutorProfile.all.includes(:user).collect { |tp| ["#{tp.user.id}) #{tp.user.first_name}",tp.user.id] if tp.user.present? } 
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