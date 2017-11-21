require 'rails_helper'

RSpec.describe StudentsController, type: :controller do

  let(:valid_attributes) {{
    first_name: "Ala",
    last_name: "Bala",
  }}

  let(:invalid_attributes) {{
    first_name: "Te",
    last_name: "Be",
  }}

  let(:valid_session) { {} }

  describe "GET #index" do
    it "returns a success response" do
      student = Student.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_success
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      student = Student.create! valid_attributes
      get :show, params: {id: student.to_param}, session: valid_session
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
      student = Student.create! valid_attributes
      get :edit, params: {id: student.to_param}, session: valid_session
      expect(response).to be_success
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Student" do
        expect {
          post :create, params: {student: valid_attributes}, session: valid_session
        }.to change(Student, :count).by(1)
      end

      it "redirects to the created student" do
        post :create, params: {student: valid_attributes}, session: valid_session
        expect(response).to redirect_to(Student.last)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: {student: invalid_attributes}, session: valid_session
        expect(response).to be_success
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {{ first_name: "Baba" }}

      it "updates the requested student" do
        student = Student.create! valid_attributes
        put :update, params: {id: student.to_param, student: new_attributes}, session: valid_session
        student.reload
        expect(student.first_name).to eq("Baba")
      end

      it "redirects to the student" do
        student = Student.create! valid_attributes
        put :update, params: {id: student.to_param, student: valid_attributes}, session: valid_session
        expect(response).to redirect_to(student)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        student = Student.create! valid_attributes
        put :update, params: {id: student.to_param, student: invalid_attributes}, session: valid_session
        expect(response).to be_success
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested student" do
      student = Student.create! valid_attributes
      expect {
        delete :destroy, params: {id: student.to_param}, session: valid_session
      }.to change(Student, :count).by(-1)
    end

    it "redirects to the students list" do
      student = Student.create! valid_attributes
      delete :destroy, params: {id: student.to_param}, session: valid_session
      expect(response).to redirect_to(students_url)
    end
  end

end
