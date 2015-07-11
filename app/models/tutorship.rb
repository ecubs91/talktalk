class Tutorship < ActiveRecord::Base
  belongs_to :user
  belongs_to :tutor_profile
  validates :terms_of_service, acceptance: true

  
# scopes defined as class methods
  class << self

    def accepted
      where(accepted: true)
    end

    def rejected
      where(accepted: false)
    end

    def pending
      where("tutorships.accepted IS NULL")
    end

    def pending_invites_from_student
      pending.where(created_by_student: true)
    end

    def rejected_invites_from_student
      rejected.where(created_by_student: true)
    end

  end 
end
