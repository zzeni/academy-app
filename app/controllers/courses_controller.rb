class CoursesController < ApplicationController
  before_action :set_course, only: [:show, :edit, :update, :destroy, :attend, :exit]
  before_action :authenticate_admin!, except: [:index, :show, :attend, :exit]

  # GET /courses
  def index
    @courses = Course.all
  end

  # GET /courses/1
  def show
  end

  # GET /courses/new
  def new
    @course = Course.new
  end

  # GET /courses/1/edit
  def edit
  end

  # POST /courses
  def create
    @course = Course.new(course_params)

    if @course.save
      redirect_to @course, notice: 'Course was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /courses/1
  def update
    if @course.update(course_params)
      redirect_to @course, notice: 'Course was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /courses/1
  def destroy
    @course.destroy
    redirect_to courses_url, notice: 'Course was successfully destroyed.'
  end

  def attend
    @student = Student.find(params[:student_id])

    begin
      @student.attend!(@course)

      redirect_to @student, notice: "Successfully enrolled in course"

    rescue Error::ApplicationError => error
      redirect_to @student, alert: error.message
    end
  end

  def exit
    @student = Student.find(params[:student_id])

    if @course.students.include?(@student)
      @course.students.delete @student
      redirect_to @student, notice: "Successfully exited course"
    else
      redirect_to @student, alert: "The student is not in this course"
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def course_params
      params.require(:course).permit(:name, :category_id, :level, :max_participants, :min_participants)
    end
end
