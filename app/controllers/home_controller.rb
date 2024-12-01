class HomeController < ApplicationController
  def index
    @user = current_user

    if params[:search].present?
      search_pattern = params[:search]
      @courses = Course.where("title ~* ? OR description ~* ?", search_pattern, search_pattern)
      if @courses.present?
        @categories = Category.where(id: @courses.pluck(:category_id).uniq).page(params[:page]).per(3)
      else
        @categories = Category.order(:name).page(params[:page]).per(3)
        flash[:notice] = t('no_courses_found')
        redirect_to root_path
      end
    else
      @categories = Category.order(:name).page(params[:page]).per(3)
    end
  end
end
