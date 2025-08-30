require 'rails_helper'

RSpec.describe LessonsController, type: :controller do
  let(:user) { create(:user, role: 'admin') }
  let(:course) { create(:course) }
  let(:lesson) { create(:lesson, course: course) }

  before do
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'GET #index' do
    it 'assigns @lessons and renders index template' do
      get :index, params: { course_id: course.id }
      expect(assigns(:lessons)).to eq([ lesson ])
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #show' do
    it 'assigns the requested lesson and renders show template' do
      get :show, params: { course_id: course.id, id: lesson.id }
      expect(assigns(:lesson)).to eq(lesson)
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #new' do
    it 'assigns a new lesson and renders new template' do
      get :new, params: { course_id: course.id }
      expect(assigns(:lesson)).to be_a_new(Lesson)
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new lesson and redirects to edit course path' do
        expect {
          post :create, params: { course_id: course.id, lesson: attributes_for(:lesson) }
        }.to change(Lesson, :count).by(1)
        expect(response).to redirect_to(edit_course_path(course))
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new lesson and re-renders new template' do
        expect {
          post :create, params: { course_id: course.id, lesson: attributes_for(:lesson, title: nil) }
        }.to_not change(Lesson, :count)
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'updates the lesson and redirects to course lessons path' do
        patch :update, params: { course_id: course.id, id: lesson.id, lesson: { title: 'Updated Title' } }
        expect(lesson.reload.title).to eq('Updated Title')
        expect(response).to redirect_to(course_lessons_path(course))
      end
    end

    context 'with invalid attributes' do
      it 'does not update the lesson and re-renders edit template' do
        patch :update, params: { course_id: course.id, id: lesson.id, lesson: { title: nil } }
        expect(lesson.reload.title).to_not be_nil
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes the lesson and redirects to course lessons path' do
      lesson
      expect {
        delete :destroy, params: { course_id: course.id, id: lesson.id }
      }.to change(Lesson, :count).by(-1)
      expect(response).to redirect_to(course_lessons_path(course))
    end
  end

  describe 'POST #mark_as_watched' do
    it 'marks the lesson as watched for the current user' do
      post :mark_as_watched, params: { course_id: course.id, id: lesson.id }
      expect(user.video_watches.find_by(lesson: lesson)).to be_present
      expect(response).to redirect_to(course_lessons_path(course))
    end
  end
end
