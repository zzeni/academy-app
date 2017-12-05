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

  context "when signed in as a normal user" do
    let(:student) { Fabricate(:student) }
    before(:each) { sign_in(student) }

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
      it "redirects to the root path" do
        get :new, params: {}, session: valid_session
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('Insufficient privileges')
      end
    end

    describe "GET #edit" do
      let(:course) { Fabricate(course, valid_attributes)}

      it "redirects to the root path" do
        get :edit, params: {id: course.to_param}, session: valid_session
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('Insufficient privileges')
      end
    end

    describe "POST #create" do
      it "redirects to the root path" do
        post :create, params: {course: valid_attributes}, session: valid_session
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('Insufficient privileges')
      end
    end

    describe "PUT #update" do
      let(:course) { Fabricate(course, valid_attributes)}

      let(:new_attributes) {{
        level: 3,
        name: "Best course ever!"
      }}

      it "redirects to the root path" do
        put :update, params: {id: course.to_param, course: new_attributes}, session: valid_session
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('Insufficient privileges')
      end
    end

    describe "DELETE #destroy" do
      let(:course) { Fabricate(course, valid_attributes)}

      it "redirects to the root path" do
        delete :destroy, params: {id: course.to_param}, session: valid_session
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('Insufficient privileges')
      end
    end

    describe "POST #attend" do
      let(:course) { Course.create! valid_attributes }

      it "enrolls a student in the course" do
        expect {
          post :attend, params: {id: course.to_param}, session: valid_session
        }.to change(course.students, :count).by(1)
      end

      it "redirects to the student" do
        post :attend, params: {id: course.to_param}, session: valid_session
        expect(response).to redirect_to(student)
      end
    end
  end
end
