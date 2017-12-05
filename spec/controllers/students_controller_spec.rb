require 'rails_helper'

RSpec.describe StudentsController, type: :controller do

  let(:valid_attributes) {{
    first_name: "Ala",
    last_name: "Bala",
    email: 'user@example.com',
    password: '123456'
  }}

  let(:invalid_attributes) {{
    first_name: "Te",
    last_name: "Be",
  }}

  let(:valid_session) { {} }

  context "when not logged in" do
    let(:student) { Student.create! valid_attributes }

    describe "GET #index" do
      it "redirects to the login page" do
        get :index, params: {}, session: valid_session
        expect(response).to redirect_to(new_student_session_path)
        expect(flash[:alert]).to eq('You need to sign in or sign up before continuing.')
      end
    end

    describe "GET #show" do
      it "redirects to the login page" do
        get :show, params: {id: student.to_param}, session: valid_session
        expect(response).to redirect_to(new_student_session_path)
        expect(flash[:alert]).to eq('You need to sign in or sign up before continuing.')
      end
    end
  end

  context "when signed in as a another user" do
    let(:student) { Student.create! valid_attributes }
    let(:logged_student) { Fabricate(:student, email: "other@example.com") }

    before(:each) { sign_in(logged_student) }

    describe "GET #index" do
      it "redirects to the root path" do
        get :index, params: {}, session: valid_session
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('Insufficient privileges')
      end
    end

    describe "GET #show" do
      it "returns a success response" do
        get :show, params: {id: student.to_param}, session: valid_session
        expect(response).to be_success
      end
    end

    describe "GET #edit" do
      it "redirects to the root path" do
        get :edit, params: {id: student.to_param}, session: valid_session
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('Insufficient privileges')
      end
    end

    describe "PUT #update" do
      let(:new_attributes) {{ name: "Baba" }}

      it "redirects to the root path" do
        put :update, params: {id: student.to_param, course: new_attributes}, session: valid_session
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('Insufficient privileges')
      end
    end

    describe "DELETE #destroy" do
      it "redirects to the root path" do
        delete :destroy, params: {id: student.to_param}, session: valid_session
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('Insufficient privileges')
      end
    end
  end

  context "when signed in as self" do
    let(:student) { Student.create! valid_attributes }

    before(:each) { sign_in(student) }

    describe "PUT #update" do
      context "with valid params" do
        let(:new_attributes) {{ first_name: "Baba" }}

        it "updates the requested student" do
          put :update, params: {id: student.to_param, student: new_attributes}, session: valid_session
          student.reload
          expect(student.first_name).to eq("Baba")
        end

        it "redirects to the student" do
          put :update, params: {id: student.to_param, student: valid_attributes}, session: valid_session
          expect(response).to redirect_to(student)
        end
      end

      context "with invalid params" do
        it "returns a success response (i.e. to display the 'edit' template)" do
          put :update, params: {id: student.to_param, student: invalid_attributes}, session: valid_session
          expect(response).to be_success
        end
      end
    end

    describe "DELETE #destroy" do
      it "redirects to the root path" do
        delete :destroy, params: {id: student.to_param}, session: valid_session
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('Insufficient privileges')
      end
    end
  end

  context "when signed in as the admin" do
    let(:admin) { Fabricate(:student, email: Student::ADMIN_EMAIL) }
    let(:student) { Student.create! valid_attributes }

    before(:each) { sign_in(admin) }


    describe "GET #index" do
      it "returns a success response" do
        get :index, params: {}, session: valid_session
        expect(response).to be_success
      end
    end

    describe "GET #show" do
      it "returns a success response" do
        get :show, params: {id: student.to_param}, session: valid_session
        expect(response).to be_success
      end
    end

    describe "GET #edit" do
      it "returns a success response" do
        get :edit, params: {id: student.to_param}, session: valid_session
        expect(response).to be_success
      end
    end

    describe "PUT #update" do
      context "with valid params" do
        let(:new_attributes) {{ first_name: "Baba" }}

        it "updates the requested student" do
          put :update, params: {id: student.to_param, student: new_attributes}, session: valid_session
          student.reload
          expect(student.first_name).to eq("Baba")
        end

        it "redirects to the student" do
          put :update, params: {id: student.to_param, student: valid_attributes}, session: valid_session
          expect(response).to redirect_to(student)
        end
      end

      context "with invalid params" do
        it "returns a success response (i.e. to display the 'edit' template)" do
          put :update, params: {id: student.to_param, student: invalid_attributes}, session: valid_session
          expect(response).to be_success
        end
      end
    end

    describe "DELETE #destroy" do
      it "destroys the requested student" do
        student # persist the record upfront
        expect {
          delete :destroy, params: {id: student.to_param}, session: valid_session
        }.to change(Student, :count).by(-1)
      end

      it "redirects to the students list" do
        delete :destroy, params: {id: student.to_param}, session: valid_session
        expect(response).to redirect_to(students_url)
      end
    end
  end
end
