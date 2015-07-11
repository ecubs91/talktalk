class City < ActiveRecord::Base
  belongs_to :country

  before_update do
    old_record = City.find(id)
    TutorProfile.where(location_city: old_record.name).update_all(location_city: self.name)
    TutorProfile.where(location_two: old_record.name).update_all(location_two: self.name)
  end

end
