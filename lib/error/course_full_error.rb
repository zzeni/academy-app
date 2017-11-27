require_relative './application_error.rb'

module Error
  class CourseFullError < ApplicationError
    def initialize(message = "Course is complete")
      super
    end
  end
end
