module Error
  class NotEligibleForCourseError < ApplicationError
    def initialize(message = "The chosen course is too difficult for the student")
      super
    end
  end
end
