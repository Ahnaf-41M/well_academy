require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
  let(:user) { create(:user) }
  let(:category) { create(:category) }

  before do
    @ability = Ability.new(user)
    @ability.can :manage, Category

    allow(controller).to receive(:current_user).and_return(user)
    allow(controller).to receive(:current_ability).and_return(@ability)
  end

  describe "GET #index" do
    it "renders the index template" do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe "GET #show" do
    it "renders the show template" do
      get :show, params: { id: category.id }
      expect(response).to render_template(:show)
    end
  end

  describe "GET #new" do
    it "renders the new template" do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe "POST #create" do
    context "when the category is saved successfully" do
      it "redirects to the index template" do
        post :create, params: { category: { name: "Sample Category", description: "Category description" } }
        expect(response).to redirect_to(categories_path)
      end
    end

    context "when the category fails to save" do
      it "renders the new template" do
        post :create, params: { category: { name: "", description: "" } }
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET #edit" do
    it "renders the edit template" do
      get :edit, params: { id: category.id }
      expect(response).to render_template(:edit)
    end
  end

  describe "PATCH #update" do
    context "when the category updates successfully" do
      it "redirects to the index template" do
        patch :update, params: { id: category.id, category: { name: "Updated Name", description: "Updated description" } }
        expect(response).to redirect_to(categories_path)
      end
    end

    context "when the category fails to update" do
      it "renders the edit template" do
        patch :update, params: { id: category.id, category: { name: "", description: "" } }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "DELETE #destroy" do
    it "redirects to the index template after deletion" do
      delete :destroy, params: { id: category.id }
      expect(response).to redirect_to(categories_path)
    end
  end
end
