require 'rails_helper'

RSpec.describe CoursesController, type: :controller do
  let(:admin) { create(:user, role: 'admin') }
  let(:teacher) { create(:user, role: 'teacher') }
  let(:student) { create(:user, role: 'student') }
  let(:category) { create(:category) }
  let(:course) { create(:course, teacher: teacher, category: category) }

  before do
    allow(controller).to receive(:current_user).and_return(admin)
  end

  describe 'GET #index' do
    it 'renders the index template for an admin' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #index_by_category' do
    it 'renders the index_by_category template' do
      get :index_by_category, params: { category_id: category.id }
      expect(response).to render_template(:index_by_category)
    end
  end

  describe 'GET #show' do
    it 'renders the show template' do
      get :show, params: { id: course.id }
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #new' do
    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'when the course is saved successfully' do
      it 'redirects to the index' do
        post :create, params: { course: attributes_for(:course, category_id: category.id, teacher_id: teacher.id) }
        expect(response).to redirect_to(courses_path)
        expect(flash[:notice]).to eq(I18n.t('courses.create.success'))
      end
    end

    context 'when the course fails to save' do
      it 'renders the new template with errors' do
        post :create, params: { course: { title: '', description: '', category_id: nil } }
        expect(response).to render_template(:new)
        expect(flash.now[:alert]).to eq(I18n.t('courses.create.failure'))
      end
    end
  end

  describe 'GET #edit' do
    it 'renders the edit template' do
      get :edit, params: { id: course.id }
      expect(response).to render_template(:edit)
    end
  end

  describe 'PATCH #update' do
    context 'when the course updates successfully' do
      it 'redirects to the index with a success notice' do
        patch :update, params: { id: course.id, course: { title: 'Updated Title' } }
        expect(response).to redirect_to(courses_path)
        expect(flash[:notice]).to eq(I18n.t('courses.update.success'))
      end
    end

    context 'when the course fails to update' do
      it 'renders the edit template with errors' do
        patch :update, params: { id: course.id, course: { title: '' } }
        expect(response).to render_template(:edit)
        expect(flash.now[:alert]).to eq(I18n.t('courses.update.failure'))
      end
    end
  end
  
  describe 'DELETE #destroy' do
    it 'redirects to the index with a success notice after deleting the course' do
      course = create(:course, teacher: teacher, category: category) # Create a valid course instance
      delete :destroy, params: { id: course.id }
      expect(response).to redirect_to(courses_path)
      expect(flash[:notice]).to eq(I18n.t('courses.destroy.success'))
    end
  end

end
