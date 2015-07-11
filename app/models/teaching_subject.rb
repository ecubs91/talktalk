class TeachingSubject < ActiveRecord::Base

  scope :teaching_subjects, -> {pluck(:name)}

  def self.get_all_teaching_subjects
    (self.teaching_subjects + DegreeSubject.get_all_degree_subjects).sort
  end


  def self.make_entries
    TeachingSubject.destroy_all
    input_ary = ["Art History",
    "Biology",  
    "Business and Management",
    "Calculus AB",
    "Calculus BC",
    "Chinese",
    "Comparative Government and Politics",
    "Environmental Science",
    "Extended Essay",
    "European History",
    "French",
    "Further Mathematics",
    "Global Perspectives and Research",
    "Greek",
    "Human Geography",
    "Latin",
    "Literature",
    "World History",
    "Macroeconomics",
    "Microeconomics",
    "Statistics",
    "Theory of Knowledge",
    "US History",
    "United States Government and Politics"]
    input_ary.each do |tec_sub|
      TeachingSubject.create(:name => tec_sub.downcase)
    end
  end
end
