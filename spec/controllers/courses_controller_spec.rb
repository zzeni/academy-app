require 'rails_helper'

RSpec.describe CoursesController, type: :controller do

  let(:valid_attributes) {{
    name: "Course 1",
    category_id: Category.create!(name: "Category 1").id,
    level: 1
  }}

  let(:invalid_attributes) {{
    category_id: 5,
    level: 0
  }}

  let(:valid_session) { {} }

  describe "GET #index" do
    it "returns a success response" do
      course = Course.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_success
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      course = Course.create! valid_attributes
      get :show, params: {id: course.to_param}, session: valid_session
      expect(response).to be_success
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new, params: {}, session: valid_session
      expect(response).to be_success
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      course = Course.create! valid_attributes
      get :edit, params: {id: course.to_param}, session: valid_session
      expect(response).to be_success
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Course" do
        expect {
          post :create, params: {course: valid_attributes}, session: valid_session
        }.to change(Course, :count).by(1)
      end

      it "redirects to the created course" do
        post :create, params: {course: valid_attributes}, session: valid_session
        expect(response).to redirect_to(Course.last)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: {course: invalid_attributes}, session: valid_session
        expect(response).to be_success
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {{
        level: 3,
        name: "Best course ever!"
      }}

      it "updates the requested course" do
        course = Course.create! valid_attributes
        put :update, params: {id: course.to_param, course: new_attributes}, session: valid_session
        course.reload
        expect(course.name).to eq("Best course ever!")
        expect(course.level).to eq(3)
      end

      it "redirects to the course" do
        course = Course.create! valid_attributes
        put :update, params: {id: course.to_param, course: valid_attributes}, session: valid_session
        expect(response).to redirect_to(course)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        course = Course.create! valid_attributes
        put :update, params: {id: course.to_param, course: invalid_attributes}, session: valid_session
        expect(response).to be_success
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested course" do
      course = Course.create! valid_attributes
      expect {
        delete :destroy, params: {id: course.to_param}, session: valid_session
      }.to change(Course, :count).by(-1)
    end

    it "redirects to the courses list" do
      course = Course.create! valid_attributes
      delete :destroy, params: {id: course.to_param}, session: valid_session
      expect(response).to redirect_to(courses_url)
    end
  end

  describe "POST #attend" do
    let(:student) { Student.create! first_name: "Ala", last_name: "Bala" }
    let(:course) { Course.create! valid_attributes }

    it "enrolls a student in the course" do
      expect {
        post :attend, params: {id: course.to_param, student_id: student.id}, session: valid_session
      }.to change(course.students, :count).by(1)
    end

    it "redirects to the course" do
        post :attend, params: {id: course.to_param, student_id: student.id}, session: valid_session
      expect(response).to redirect_to(course)
    end
  end

end
