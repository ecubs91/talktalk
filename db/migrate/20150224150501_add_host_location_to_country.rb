class AddHostLocationToCountry < ActiveRecord::Migration
  def change
    add_column :countries, :host_location, :boolean
  end
end
