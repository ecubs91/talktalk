ActiveAdmin.register User do

  menu :priority => 3

  actions :all, :except => [:new,:edit,:destroy]

  index do
    column :id
    column :first_name
    column :email
    column "My Tutor Profile" do |u|
      (link_to "Tutor Profile", admin_tutor_profile_path(u.tutor_profile)) if u.tutor_profile.present?
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
