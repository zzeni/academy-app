module Error
  class TooManyCoursesAtATimeError < StandardError
    def initialize
      super
      message = "The student can't attend more courses"
    end
  end
end
