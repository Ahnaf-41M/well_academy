class HomeController < ApplicationController
  ITEMS_PER_PAGE = 5

  def index
    @user = current_user

    if params[:search].present?
      search_pattern = params[:search]
      @courses = Course.where("title ILIKE ? OR description ILIKE ?",
                              "%#{search_pattern}%", "%#{search_pattern}%")
      if @courses.present?
        @categories = Category.where(id: @courses.pluck(:category_id).uniq).page(params[:page]).per(5)
        @courses = Course.where(category_id: @categories.pluck(:id))
                         .order(:title)
                         .group_by(&:category_id)
        render :index
      else
        @categories = Category.select("DISTINCT categories.*")
                              .joins(:courses)
                              .order(:name)
                              .page(params[:page])
                              .per(ITEMS_PER_PAGE)
        @courses = Course.where(category_id: @categories.pluck(:id))
                         .order(:title)
                         .group_by(&:category_id)
        flash[:notice] = t("no_courses_found")
        render :index
      end
    else
      @categories = Category.select("DISTINCT categories.*")
                            .joins(:courses)
                            .order(:name)
                            .page(params[:page])
                            .per(ITEMS_PER_PAGE)
      @courses = Course.where(category_id: @categories.pluck(:id))
                       .order(:title)
                       .group_by(&:category_id)
    end
  end
end
