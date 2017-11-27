require 'rails_helper'

RSpec.describe "Courses", type: :request do
  describe "POST /courses/:id/attend" do
    let(:course) { Course.create!(name: "Course 1", level: 1, category: category1 ) }
    let(:student) { Student.create!(first_name: "Ala", last_name: "Bala") }
    let(:category1) { Category.create!(name: "Bla Bla Bla") }
    let(:category2) { Category.create!(name: "Ala Bala") }
    let(:other_course_same_cat) { Course.new(name: "Course 2", level: 1, category: category1 ) }
    let(:other_course_other_cat) { Course.new(name: "Course 3", level: 1, category: category2 ) }

    let(:path) { "/courses/#{course.id}/attend" }

    it 'should error if the course is complete' do
      course.update max_participants: 0

      post path, params: { student_id: student.id }

      expect(response).to render_template(:show)
      expect(course.students.size).to eq(0)
      expect(response.body).to include(Error::CourseFullError.new.message)
    end

    it 'should error if the course is too difficult for the student' do
      course.update level: 3
      student.courses << other_course_same_cat

      post path, params: { student_id: student.id }

      expect(response).to render_template(:show)
      expect(course.students.size).to eq(0)
      expect(response.body).to include(Error::NotEligibleForCourseError.new.message)
    end

    it 'should error if the student has already attended two other actual courses' do
      student.courses << other_course_same_cat
      student.courses << other_course_other_cat

      post path, params: { student_id: student.id }

      expect(response).to render_template(:show)
      expect(course.students.size).to eq(0)
      expect(response.body).to include(Error::TooManyCoursesAtATimeError.new.message)
    end

    it 'should succeed if student has attended unlimited other potential courses' do
      10.times do |i|
        Course.create! name: "Other course #{i}", category: category1, min_participants: 2, students: [student], level: 1
      end

      expect {
        post path, params: { student_id: student.id }
      }.to change {
        student.courses.count
      }.by(1)

      expect(course.students).to eq([student])
      expect(response.body).to include('Successfully enrolled in course')
    end

    context "when student has already enrolled in one other actual course" do
      before(:each) do
        student.courses << other_course_other_cat
      end

      it 'should succeed if all is correct' do
        post path, params: { student_id: student.id }
        expect(student.courses).to include(course)
        expect(course.students).to eq([student])
      end

      it 'should unsubscribe the student from all other potential courses if the current course is actual' do
        10.times do |i|
          Course.create! name: "Other course #{i}", category: category1, min_participants: 2, students: [student], level: 1
        end

        course.update :min_participants, 1

        post path, params: { student_id: student.id }

        expect(Course.count).to eq(12)
        expect(student.courses).to include(course)
        expect(course.students).to eq([student])
        expect(student.courses.map(&:id)).to match_array([other_course_other_cat.id, course.id])
      end
    end
  end
end
