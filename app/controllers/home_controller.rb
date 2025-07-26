class HomeController < ApplicationController
  CATEGORIES_PER_PAGE = 5
  COURSES_PER_CATEGORY = 6
  COURSES_IN_SEARCH_PAGE = 10

  def index
    @categories = Category.select("DISTINCT categories.*")
                          .joins(:courses)
                          .order(:name)
                          .page(params[:page])
                          .per(CATEGORIES_PER_PAGE)
    @courses = {}
    @categories.each do |category|
      @courses[category.id] = category.courses
                                      .includes(
                                        :teacher,
                                        :lessons,
                                        :display_picture_attachment
                                      )
                                      .order(:title)
                                      .limit(COURSES_PER_CATEGORY)
    end
  end

  def search
    pattern = params[:search]
    @courses = Course.where("title ILIKE ? OR description ILIKE ?", "%#{pattern}%", "%#{pattern}%")
                     .includes(:teacher, :lessons, :display_picture_attachment)
                     .order(:title)
                     .page(params[:page])
                     .per(COURSES_IN_SEARCH_PAGE)

    if @courses.empty?
      flash[:notice] = t("no_courses_found")
      redirect_to root_path
    end
  end
end
