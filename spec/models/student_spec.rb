require 'rails_helper'

RSpec.describe Student, type: :model do
  let(:student) { Student.new(first_name: 'Baba', last_name: 'Miii') }

  describe "::save" do
    it 'should error if first_name is not specified' do
      student.first_name = nil
      expect(student.save).to eq(false)
      expect(student.errors.first).to eq([:first_name, "can't be blank"])
    end

    it 'should error if last_name is not specified' do
      student.last_name = nil
      student.save
      expect(student.errors.first).to eq([:last_name, "can't be blank"])
    end

    it 'should error if first_name is longer than 15 characters' do
      student.first_name = 'A'*16
      expect(student.save).to eq(false)
      expect(student.errors.first).to eq([:first_name, "is too long (maximum is 15 characters)"])
    end

    it 'should error if last_name is not specified' do
      student.last_name = 'A'*16
      expect(student.save).to eq(false)
      expect(student.errors.first).to eq([:last_name, "is too long (maximum is 15 characters)"])
    end

    it 'should save the user if all params are correct' do
      expect(student.save).to eq(true)
      expect(student.errors.size).to eq(0)
      expect(student.persisted?).to eq(true)
    end
  end

  describe '#attend' do
    let(:category1) { Category.create!(name: "Bla Bla Bla") }
    let(:category2) { Category.create!(name: "Ala Bala") }
    let(:course) { Course.new(name: "Course 1", level: 1, category: category1 ) }
    let(:other_course_same_cat) { Course.new(name: "Course 2", level: 1, category: category1 ) }
    let(:other_course_other_cat) { Course.new(name: "Course 3", level: 1, category: category2 ) }

    before(:each) {
      student.save!
    }

    it 'should error if the course is complete' do
      course.max_participants = 0
      course.save!
      expect {
        student.attend(course)
      }.to raise_error(Error::CourseFullError)
    end

    it 'should error if the course is too difficult for the student' do
      course.level = 3
      course.save!
      student.courses = [other_course_same_cat]
      student.save!

      expect {
        student.attend(course)
      }.to raise_error(Error::NotEligibleForCourseError)
    end

    it 'should error if the student has already attended two other actual courses' do
      student.courses = [other_course_same_cat, other_course_other_cat]
      student.save!

      expect {
        student.attend(course)
      }.to raise_error(Error::TooManyCoursesAtATimeError)
    end

    it 'should succeed if student has attended unlimited other potential courses' do
      10.times do |i|
        Course.create! name: "Other course #{i}", category: category1, min_participants: 2, students: [student], level: 1
      end

      expect {
        student.attend(course)
      }.to change {
        student.courses.count
      }.by(1)
    end

    context "when student has already enrolled in one other actual course" do
      before(:each) do
        student.courses = [other_course_other_cat]
        student.save!
      end

      it 'should succeed if all is correct' do
        expect {
          student.attend(course)
        }.to change {
          student.courses.count
        }.by(1)
      end

      it 'should unsubscribe the student from all other potential courses if the current course is actual' do
        10.times do |i|
          Course.create! name: "Other course #{i}", category: category1, min_participants: 2, students: [student], level: 1
        end

        course.update_attribute :min_participants, 1

        expect {
          student.attend(course)
        }.to change {
          student.courses.count
        }.by(-9)

        expect(Course.count).to eq(12)
        expect(student.courses.map(&:id)).to match_array([other_course_other_cat.id, course.id])
      end
    end
  end
end
