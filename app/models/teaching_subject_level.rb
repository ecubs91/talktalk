class TeachingSubjectLevel < ActiveRecord::Base
  belongs_to :tutor_teaching_subject
  validates :level, :uniqueness => {:scope => :tutor_teaching_subject}

  after_create :set_proper_visibility
  after_update :set_proper_visibility
  after_destroy :set_proper_visibility

  def set_proper_visibility
    self.tutor_teaching_subject.tutor_profile.set_proper_visibility
  end

end
