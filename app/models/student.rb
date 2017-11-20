class Student < ApplicationRecord
  has_and_belongs_to_many :courses

  validates :first_name, presence: true, length: { in: 3..15 }
  validates :last_name, presence: true, length: { in: 3..15 }

  def attend(course)
    raise Error::CourseFullError if course.complete?

    courses_in_the_same_category = courses.where(category_id: course.category_id)
    raise Error::TooManyCoursesAtATimeError if courses.size >= 2

    max_lvel_for_category = courses_in_the_same_category.maximum(:level)
    raise Error::NotEligibleForCourseError if course.level - 1 > (max_lvel_for_category||0)

    courses << course
  end
end
