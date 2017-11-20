class Student < ApplicationRecord
  has_and_belongs_to_many :courses

  validates :first_name, presence: true, length: { in: 3..15 }
  validates :last_name, presence: true, length: { in: 3..15 }

  def attend(course)
    raise Error::CourseFullError if course.complete?
    raise Error::TooManyCoursesAtATimeError if actual_courses.size >= 2
    raise Error::NotEligibleForCourseError if course.level - 1 > (max_level_for_category(course.category)||0)

    courses << course
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
