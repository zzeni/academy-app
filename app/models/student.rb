class Student < ApplicationRecord
  MAX_ACTUAL_COURSES = 2

  has_and_belongs_to_many :courses

  validates :first_name, presence: true, length: { in: 3..15 }
  validates :last_name, presence: true, length: { in: 3..15 }

  def attend(course)
    raise Error::CourseFullError.new if course.complete?
    raise Error::TooManyCoursesAtATimeError.new if actual_courses.size >= MAX_ACTUAL_COURSES
    raise Error::NotEligibleForCourseError.new if course.level - 1 > (max_level_for_category(course.category)||0)

    courses << course

    if actual_courses.size >= MAX_ACTUAL_COURSES
      courses.delete(courses.all - actual_courses)
    end
  end

  private
  def actual_courses
    courses.all.select do |course|
      course.actual?
    end
  end

  def max_level_for_category(category)
    courses_in_the_same_category = courses.where(category_id: category.id)
    courses_in_the_same_category.maximum(:level)
  end
end
