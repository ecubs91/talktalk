# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.delete_all
@a = User.create!(email: 'harry@test.com', password: 'abcdefgh', password_confirmation: 'abcdefgh', :first_name => 'Harry', :last_name => 'Lee')
@a.save

@b = User.create!(email: 'josh@test.com', password: 'abcdefgh', password_confirmation: 'abcdefgh', :first_name => 'Josh', :last_name => 'Manson')
@b.save

@c = User.create!(email: 'leesu@test.com', password: 'abcdefgh', password_confirmation: 'abcdefgh', :first_name => 'Leesu', :last_name => 'Jackson')
@c.save

Mailboxer::Conversation.delete_all
@con = @a.send_message(@b, 'Hi This is an uppersixth from Wellington College...', 'X has requested tuition on Biology')
#@b.reply_to_conversation(@con, 'body', 'subject')
@b.reply_to_all(@con, 'Hi Thanks for getting in touch....')
#@a.reply_to_conversation(@con, 'body', 'subject')
@a.reply_to_all(@con, 'I am thinking of preparing for my alevel exams with some help over the christmas break')

TutorProfile.delete_all
@d = TutorProfile.create!(university: 'Oxford', degree_subject: 'Biochemistry', teaching_subject: 'biology', user_id: 1)
@d.save
@e = TutorProfile.create!(university: 'Cambridge', degree_subject: 'Chemistry', teaching_subject: 'chemistry', user_id: 2)
@e.save
@f = TutorProfile.create!(university: 'Harvard', degree_subject: 'Medicine', teaching_subject: 'biology, chemistry', user_id: 3)
@f.save

Enquiry.delete_all
@x = Enquiry.create!(subject: 'Biology', level: 'Alevel', location: 'oxford', user_id: 2)
@x.save
@y = Enquiry.create!(subject: 'Chemistry', level: 'IB', location: 'london', user_id: 2)
@y.save

Tutorship.delete_all
@f = Tutorship.create!(tutor_profile_id: 1, user_id: 2, hourly_rate: 30, hours_a_week: 6, weeks: 4)


# Seed file entries created by chintan for demonstration

DegreeSubject.make_entries
TeachingSubject.make_entries
Level.make_entries

# below code will create one country and according cities
@country = Country.create(:name => "india")
@country.cities.new(:name => "ahmedabad")
@country.cities.new(:name => "baroda")
@country.cities.new(:name => "surat")

@country = Country.create(:name => "UK")
@country.cities.new(:name => "London")
@country.cities.new(:name => "Oxford")
@country.cities.new(:name => "Cambridge")

@country = Country.create(:name => "한국", :host_location => true)
@country.cities.new(:name => "서울")
@country.cities.new(:name => "대전")
@country.cities.new(:name => "부산")


# below code will create one university
University.create(:name => "Oxford")
University.create(:name => "Cambridge")