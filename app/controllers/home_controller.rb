class HomeController < ApplicationController
  def index
    @user = current_user
    @categories = Category.all

    if params[:search].present?
      search_pattern = params[:search]
      @courses = Course.where("title ~* ? OR description ~* ?", search_pattern, search_pattern)
      @categories = Category.all
      if @courses.present?
        @categories = Category.where(id: @courses.pluck(:category_id).uniq)
      end
    end
  end
end
