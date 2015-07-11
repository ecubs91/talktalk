class DegreeSubjectLevel < ActiveRecord::Base
  belongs_to :tutor_degree_subject
  validates :level, :uniqueness => {:scope => :tutor_degree_subject}

  after_create :set_proper_visibility
  after_update :set_proper_visibility
  after_destroy :set_proper_visibility

  def set_proper_visibility
    if tutor_degree_subject.tutor_profile.present?
      self.tutor_degree_subject.tutor_profile.set_proper_visibility
    end
  end

end
