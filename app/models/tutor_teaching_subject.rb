class TutorTeachingSubject < ActiveRecord::Base
  belongs_to :tutor_profile
  has_many :teaching_subject_levels, :dependent => :destroy
  validates :teaching_subject, :uniqueness => {:scope => :tutor_profile}

  after_create :set_proper_visibility
  after_update :set_proper_visibility
  after_destroy :set_proper_visibility

  def set_proper_visibility
    self.tutor_profile.set_proper_visibility
  end

end
