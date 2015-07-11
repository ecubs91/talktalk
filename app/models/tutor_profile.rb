class TutorProfile < ActiveRecord::Base
  
  has_attached_file :image, :styles => { :medium => "200x200>", :small => "100x100#", :large => "500x500>" }, :class => "img-circle", :default_url => "default.jpg", :processors => [:cropper],
                    :storage => :s3,
                    :bucket => "gurumek1",
                    :s3_credentials => "#{Rails.root}/config/s3.yml"
  
  has_attached_file :image2,
                    :storage => :s3,
                    :bucket => "gurumekcertificate",
                    :s3_credentials => "#{Rails.root}/config/s3.yml"
  
  
  
  validates :university, :hourly_rate, presence: true
  validates :terms_of_service, acceptance: true

  # --- Parameters for image copping
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

  belongs_to :user
  has_many :tuitions
  has_many :reviews
  has_many :tutor_degree_subjects
  has_many :tutor_teaching_subjects
  
      # agreed tutorships where this user is the tutor
  has_many  :tutorships_as_tutor,
              ->{ Tutorship.accepted },
              class_name: "Tutorship",
  foreign_key: :tutor_profile_id

  # invites asking this user to be a tutor
  has_many  :pending_invites_to_be_a_tutor,
              ->{ Tutorship.pending_invites_from_student },
              class_name: "Tutorship",
  foreign_key: :tutor_profile_id

  # rejected invites asking this user to be a tutor
  has_many  :rejected_invites_to_be_a_tutor,
              ->{ Tutorship.rejected_invites_from_student },
              class_name: "Tutorship",
  foreign_key: :tutor_profile_id

  after_create :set_proper_visibility
  after_update :set_proper_visibility

  scope :filter_by_country, ->(country_name) { where("country = (?) OR location = (?)", country_name,country_name) }
  scope :filter_by_city, ->(city_name) { where("location_two = (?) OR location_city = (?)",city_name,city_name) }
  scope :filter_by_university, ->(university) { where(:university => university) }

  def self.get_all_subjects_with_levels(subject,levels)
    result_tutor_profiles = []
    self.all.each do |tp|
      if tp.visibility
        if tp.is_tutor_appropriate?(subject,levels)
          result_tutor_profiles << tp
        end
      end
    end
    return result_tutor_profiles
  end


  def self.get_matching_subject(subject)
    result_tutor_profiles = []
    self.all.each do |tp|
      if tp.visibility
        if tp.is_tutor_matching_subject?(subject)
          result_tutor_profiles << tp
        end
      end
    end
    return result_tutor_profiles
  end


  def self.get_matching_levels(level)
    result_tutor_profiles = []
    self.all.each do |tp|
      if tp.visibility
        if tp.is_tutor_matching_level?(level)
          result_tutor_profiles << tp
        end
      end
    end
    return result_tutor_profiles
  end


  def is_tutor_matching_subject?(subject)
    degree_subjects = []
    teaching_subjects = []
    #  Search in degree subjects
    degree_subjects = self.tutor_degree_subjects.pluck(:degree_subject)
    teaching_subjects = self.tutor_teaching_subjects.pluck(:teaching_subject)

    all_subjects = degree_subjects+teaching_subjects
    if all_subjects.include?(subject)
      return true
    else
      return false
    end
  end


  def is_tutor_matching_level?(level)
    degree_levels = []
    teaching_levels = []
    #  Search in degree subjects
    degree_levels = self.tutor_degree_subjects.first.degree_subject_levels.where("level IN (?)",level).pluck(:level) rescue []

    self.tutor_teaching_subjects.each { |tts| teaching_levels = teaching_levels + tts.teaching_subject_levels.pluck(:level) }

    all_levels = degree_levels + teaching_levels

    if (all_levels & level).blank?
      return false
    else
      return true
    end
  end


  def is_tutor_appropriate?(subject,levels)
    degree_levels = []
    teaching_levels = []

    #  Search in degree subjects
    self.tutor_degree_subjects.where(:degree_subject => subject).each do |ds|
      degree_levels = ds.degree_subject_levels.pluck("level")
    end

    #  Search in teaching subjects
    self.tutor_teaching_subjects.where(:teaching_subject => subject).each do |ts|
      teaching_levels = ts.teaching_subject_levels.pluck("level")
    end

    all_levels = degree_levels + teaching_levels

    if all_levels.blank?
      return false
    else
      return (all_levels & levels).blank? ? false : true
    end
  end


  def levelwise_subjects
    if self.tutor_teaching_subjects.present?
      epl = Level.exam_preparation_levels
      tsl = {
          epl[0] => [],
          epl[1] => [],
          epl[2] => [],
          epl[3] => [],
          epl[4] => [],
          epl[5] => []
      }
      self.tutor_teaching_subjects.each do |tts|
        tts_levels = tts.teaching_subject_levels.pluck(:level)
        tsl.each do |k,v|
          if tts_levels.include?(k)
            v << tts.teaching_subject.capitalize
          end
        end
      end
      return tsl
    end
  end


  def set_proper_visibility
    tutor_profile = self
    vib = false
    if !(tutor_profile.university.nil?) #check presence of university
      if !(tutor_profile.tutor_degree_subjects.blank?) #check presence of degree subject
        if !(tutor_profile.tutor_degree_subjects.first.degree_subject_levels.blank?) #check presence of degree subjects' levels
          if !(tutor_profile.tutor_teaching_subjects.blank?) #check presence of teaching subject
            if !(tutor_profile.tutor_teaching_subjects.map{|tts| tts.teaching_subject_levels.blank? }.include?(true)) #check at least one level is present in all teaching subjects
              vib = true
            end
          end
        end
      end
    end
    unless tutor_profile.visibility==vib
      tutor_profile.update_attributes(:visibility => vib)
    end
  end

  def self.set_all_users_visibility_script
    self.all.each do |tp|
      tp.set_proper_visibility
    end
  end

  def self.enable_all_users_visibility_script
    self.update_all(:visibility => true)
  end


  # --- Image cropping methods
  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end

  def reprocess_avatar
    image.reprocess! :small
  end

  def avatar_geometry(style = :original)
    @geometry ||= {}
    @geometry[style] ||= Paperclip::Geometry.from_file(image.url(:original))
    # @geometry[style] ||= Paperclip::Geometry.from_file(image.path(style))
  end

  def my_likes
    self.reviews.likes
  end

  def my_dislikes
    self.reviews.dislikes
  end

  def my_likes_count
    my_likes.length
  end

  def my_dislikes_count
    my_dislikes.length
  end

end
# return the comparison result