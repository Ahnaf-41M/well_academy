require 'rails_helper'

RSpec.describe EnrollmentsController, type: :controller do
  let(:admin) { create(:user, role: 'admin') }
  let(:student) { create(:user, role: 'student') }
  let(:course) { create(:course) }
  let(:enrollment) { create(:enrollment, student: student, course: course) }

  before do
    allow(controller).to receive(:current_user).and_return(admin)
  end

  describe 'GET #index' do
    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end

    it 'displays a notice if there are no enrollments' do
      Enrollment.destroy_all
      get :index
      expect(flash.now[:notice]).to eq(I18n.t('enrollments.index.empty'))
    end
  end

  describe 'GET #show' do
    it 'renders the show template' do
      get :show, params: { id: enrollment.id }
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
    context 'with valid attributes' do
      it 'creates a new enrollment and redirects to show' do
        expect {
          post :create, params: { enrollment: { student_id: student.id, course_id: course.id, enrolled_at: Time.current, progress: 0.5, completion_status: 'in_progress' } }
        }.to change(Enrollment, :count).by(1)
        expect(response).to redirect_to(enrollment_path(assigns(:enrollment)))
        expect(flash[:notice]).to eq(I18n.t('enrollments.create.success'))
      end
    end

    context 'with invalid attributes' do
      it 'renders the new template with a failure alert' do
        post :create, params: { enrollment: { student_id: nil, course_id: nil } }
        expect(response).to render_template(:new)
        expect(flash.now[:alert]).to eq(I18n.t('enrollments.create.failure'))
      end
    end
  end

  describe 'GET #edit' do
    it 'renders the edit template' do
      get :edit, params: { id: enrollment.id }
      expect(response).to render_template(:edit)
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'updates the enrollment and redirects to show' do
        patch :update, params: { id: enrollment.id, enrollment: { progress: 0.9 } }
        expect(response).to redirect_to(enrollment_path(assigns(:enrollment)))
        expect(flash[:notice]).to eq(I18n.t('enrollments.update.success'))
        expect(enrollment.reload.progress).to eq(0.9)
      end
    end

    context 'with invalid attributes' do
      it 'renders the edit template with a failure alert' do
        patch :update, params: { id: enrollment.id, enrollment: { progress: 1.5 } }
        expect(response).to render_template(:edit)
        expect(flash.now[:alert]).to eq(I18n.t('enrollments.update.failure'))
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the enrollment and redirects to index with a success notice' do
      delete :destroy, params: { id: enrollment.id }
      expect(response).to redirect_to(enrollments_path)
      expect(flash[:notice]).to eq(I18n.t('enrollments.destroy.success'))
      expect(Enrollment.exists?(enrollment.id)).to be_falsey
    end

    it 'sets an alert if the enrollment cannot be deleted' do
      allow_any_instance_of(Enrollment).to receive(:destroy).and_return(false)
      delete :destroy, params: { id: enrollment.id }
      expect(response).to redirect_to(enrollments_path)
      expect(flash[:alert]).to eq(I18n.t('enrollments.destroy.failure'))
    end
  end
end
