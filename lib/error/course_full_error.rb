module Error
  class CourseFullError < StandardError
    def initialize
      super
      message = "Course is complete"
    end
  end
end
