class Enquiry < ActiveRecord::Base
	validates :subject, :level, presence: true

  belongs_to :user
	
end
