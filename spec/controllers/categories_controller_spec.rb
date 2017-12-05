require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
  let(:valid_attributes) {
    { name: "Awesome Category" }
  }

  let(:invalid_attributes) {
    { name: "Awesome Category that has a too long name" }
  }

  let(:valid_session) { {} }

  context "when not logged in" do
    describe "GET #index" do
      it "redirects to the login page" do
        get :index, params: {}, session: valid_session
        expect(response).to redirect_to(new_student_session_path)
        expect(flash[:alert]).to eq('You need to sign in or sign up before continuing.')
      end
    end
  end

  context "when signed in as a normal user" do
    let(:student) { Fabricate(:student) }

    before(:each) { sign_in(student) }

    describe "GET #index" do
      it "returns a success response" do
        get :index, params: {}, session: valid_session
        expect(response).to be_success
      end
    end
  end

  context "when signed in as the admin user" do
    let(:admin) { Fabricate(:student, email: Student::ADMIN_EMAIL) }
    let(:category) { Category.create! valid_attributes }

    before(:each) do
      sign_in admin
    end

    describe "GET #index" do
      it "returns a success response" do
        get :index, params: {}, session: valid_session
        expect(response).to be_success
      end
    end

    describe "GET #show" do
      it "returns a success response" do
        get :show, params: {id: category.to_param}, session: valid_session
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
        get :edit, params: {id: category.to_param}, session: valid_session
        expect(response).to be_success
      end
    end

    describe "POST #create" do
      context "with valid params" do
        it "creates a new Category" do
          expect {
            post :create, params: {category: valid_attributes}, session: valid_session
          }.to change(Category, :count).by(1)
        end

        it "redirects to the created category" do
          post :create, params: {category: valid_attributes}, session: valid_session
          expect(response).to redirect_to(Category.last)
        end
      end

      context "with invalid params" do
        it "returns a success response (i.e. to display the 'new' template)" do
          post :create, params: {category: invalid_attributes}, session: valid_session
          expect(response).to be_success
        end
      end
    end

    describe "PUT #update" do
      context "with valid params" do
        let(:new_attributes) {{ name: "Nomer 1" }}

        it "updates the requested category" do
          put :update, params: {id: category.to_param, category: new_attributes}, session: valid_session
          category.reload
          expect(category.name).to eq("Nomer 1")
        end

        it "redirects to the category" do
          put :update, params: {id: category.to_param, category: valid_attributes}, session: valid_session
          expect(response).to redirect_to(category)
        end
      end

      context "with invalid params" do
        it "returns a success response (i.e. to display the 'edit' template)" do
          put :update, params: {id: category.to_param, category: invalid_attributes}, session: valid_session
          expect(response).to be_success
        end
      end
    end
  end
end
