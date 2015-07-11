class University < ActiveRecord::Base
  default_scope {order(:name)}
  before_update do
    old_record = University.find(id)
    TutorProfile.where(university: old_record.name).update_all(university: self.name)
  end
end
