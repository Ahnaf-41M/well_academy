class HomeController < ApplicationController
  ITEMS_PER_PAGE = 5

  def index
    @categories = Category.select("DISTINCT categories.*")
                          .joins(:courses)
                          .includes(courses: [
                            :teacher,
                            :display_picture_attachment
                          ])
                          .order(:name)
                          .page(params[:page])
                          .per(ITEMS_PER_PAGE)
    @courses = @categories.flat_map(&:courses)
                          .sort_by(&:title)
                          .group_by(&:category_id)
  end

  def search
    pattern = params[:search]
    @courses = Course.where("title ILIKE ? OR description ILIKE ?", "%#{pattern}%", "%#{pattern}%")
                     .includes(:teacher, :display_picture_attachment)
                     .order(:title)
                     .page(params[:page])
                     .per(ITEMS_PER_PAGE)

    if @courses.empty?
      flash[:notice] = t("no_courses_found")
      redirect_to root_path
    end
  end
end
