class Blog < ActiveRecord::Base
    has_attached_file :image,
                      :storage => :s3,
                      :bucket => "gurumekblog",
                      :s3_credentials => "#{Rails.root}/config/s3.yml"
                  
    validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
    
  belongs_to :user
  belongs_to :category
  has_many :replies
  validates_presence_of :user_id
  
end
