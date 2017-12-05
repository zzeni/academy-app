require 'fabrication'
require 'faker'

Student.delete_all
Course.delete_all
Category.delete_all

category_names = ["Programming", "Music", "Cooking", "Robots", "Tai-Chi"]

category_names.each do |name|
  Category.create! name: name
end

programming_courses = ["Ruby Programming", "Ruby on Rails", "Python for ninjas"]

programming_courses.each do |name|
  [1, 2, 3].each do |level|
    Course.create name: name,
                  level: level,
                  category: Category.find_by_name("Programming"),
                  min_participants: 3,
                  max_participants: 10
  end
end

30.times do |i|
  Fabricate(:student, email: "student_#{i}@example.com")
end
