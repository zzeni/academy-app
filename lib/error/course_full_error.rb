module Error
  class CourseFullError < ApplicationError
    def initialize(message = "Course is complete")
      super
    end
  end
end
