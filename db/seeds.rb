category_names = ["Programming", "Music", "Cooking", "Robots", "Tai-Chi"]

category_names.each do |name|
  Category.create! name: name
end

programming_courses = ["Ruby Programming", "Ruby on Rails", "Pyton for ninjas"]

programming_courses.each do |name|
  [1, 2, 3].each do |level|
    Course.create name: name,
                  level: level,
                  category: Category.find_by_name("Programming"),
                  min_participants: 3,
                  max_participants: 10
  end
end

