ActiveAdmin.register Level do

  permit_params :utf8, :authenticity_token, :name, :category, :commit

  index do
    id_column
    column :name
    column :category
    actions
  end


  form do |f|
    inputs 'Details' do
      input :name
      input :category, as: :select, collection: Level::CATEGORY, include_blank: false
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
