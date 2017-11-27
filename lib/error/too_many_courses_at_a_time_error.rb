require_relative './application_error.rb'

module Error
  class TooManyCoursesAtATimeError < ApplicationError
    def initialize(message = "The student cannot attend more courses")
      super
    end
  end
end
