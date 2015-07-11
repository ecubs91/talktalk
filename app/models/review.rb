class Review < ActiveRecord::Base
	belongs_to :user
	belongs_to :tutor
  belongs_to :tutor_profile

	validates_presence_of :comment
  #validates :vote, :inclusion => {:in => [true, false]}
	# validates :rating, numericality: {
	# 	greater_than_or_equal_to: 1,
	# 	message: "can only be a whole number between 1 and 5"
	# }

  scope :likes, -> {where(:vote => true)}
  scope :dislikes, -> {where(:vote => false)}
	
end
