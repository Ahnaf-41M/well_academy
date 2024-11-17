# spec/controllers/users_controller_spec.rb
require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user, :admin) } # Assuming you have a factory for User

  before do
    allow(controller).to receive(:current_user).and_return(user)
  end
  describe "POST #create" do
    context "with valid attributes" do
      it "creates a new user and redirects to root path" do
        post :create, params: { user: attributes_for(:user) }

        # Check if the response redirects to the root path
        expect(response).to redirect_to(root_path)
      end
    end

    context "with invalid attributes" do
      it "does not create a user and renders the new template" do
        post :create, params: { user: attributes_for(:user, email: nil) }

        # Check if the 'new' template is rendered due to invalid data
        expect(response).to render_template(:new)
      end
    end
  end

  describe "PATCH #update" do
    context "with valid attributes" do
      it "updates the user and redirects to the user path" do
        patch :update, params: { id: user.id, user: { name: "Updated Name" } }

        # Check if the user was updated and redirected to the user show path
        expect(response).to redirect_to(user_path(user))
      end
    end

    context "with invalid attributes" do
      it "does not update the user and renders the edit template" do
        patch :update, params: { id: user.id, user: { email: nil } }

        # Check if the 'edit' template is rendered
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "DELETE #destroy" do
    it "deletes the user and redirects to users path" do
      delete :destroy, params: { id: user.id }

      # Check if the response redirects to users path
      expect(response).to redirect_to(users_path)
    end
  end

  describe "GET #become_teacher" do
    it "renders the become_teacher template" do
      get :become_teacher, params: { id: user.id } # Use the correct route path

      # Ensure the 'become_teacher' template is rendered
      expect(response).to render_template(:become_teacher)
    end
  end

  describe "GET #show" do
    it "renders the show template" do
      get :show, params: { id: user.id }

      # Ensure the 'show' template is rendered
      expect(response).to render_template(:show)
    end
  end

  describe "GET #edit" do
    it "renders the edit template" do
      get :edit, params: { id: user.id }

      # Ensure the 'edit' template is rendered
      expect(response).to render_template(:edit)
    end
  end

  describe "GET #new" do
    it "renders the new template" do
      get :new

      # Ensure the 'new' template is rendered
      expect(response).to render_template(:new)
    end
  end

end
