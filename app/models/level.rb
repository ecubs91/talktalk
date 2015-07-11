class Level < ActiveRecord::Base
  CATEGORY=["University Admissions","Exam Preparation"]

  scope :get_all_levels, -> {order(:id).pluck(:name,:category)}
  scope :university_admission_levels, -> {where(:category => CATEGORY[0]).pluck(:name)}
  scope :exam_preparation_levels, -> {where(:category => CATEGORY[1]).pluck(:name)}

  ## Active Record Callbacks
  before_update do
    old_level = Level.find(id).name
    if category==CATEGORY[0]
      DegreeSubjectLevel.where(:level => old_level).update_all(:level => name)
    elsif category==CATEGORY[1]
      TeachingSubjectLevel.where(:level => old_level).update_all(:level => name)
    end
  end

  before_destroy do
    if category==CATEGORY[0]
      DegreeSubjectLevel.where(:level => name).destroy_all
    elsif category==CATEGORY[1]
      TeachingSubjectLevel.where(:level => name).destroy_all
    end
  end

  def self.make_entries
    Level.destroy_all
    input_ary = [
    ["University Q&A",CATEGORY[0]],
    ["Personal Statement",CATEGORY[0]],
    ["Oxbridge Admissions Test",CATEGORY[0]],
    ["Oxbridge Interview",CATEGORY[0]],
    ["BMAT",CATEGORY[0]],
    ["LNAT",CATEGORY[0]],
    ["A-Level",CATEGORY[1]],
    ["IB (HL)",CATEGORY[1]],
    ["IB (SL)",CATEGORY[1]],
    ["Pre-U",CATEGORY[1]],
    ["AP",CATEGORY[1]],
    ["SAT II",CATEGORY[1]]
    ]
    input_ary.each do |level|
      Level.create(:name => level[0], :category => level[1])
    end
  end
end
