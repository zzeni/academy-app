class CreateCoursesStudents < ActiveRecord::Migration[5.1]
  def change
    create_table :courses_students do |t|
      t.integer :course_id
      t.integer :student_id
    end

    add_foreign_key :courses_students, :courses
    add_foreign_key :courses_students, :students
  end
end
