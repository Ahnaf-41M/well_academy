class CategoriesController < ApplicationController
  CATEGORIES_PER_PAGE = 5

  load_and_authorize_resource

  def index
    @categories = Category.page(params[:page]).per(CATEGORIES_PER_PAGE)
    if @categories.empty?
      flash.now[:notice] = t("categories.index.empty")
    end
  end

  def show
    @category = Category.find(params[:id])
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to categories_path, notice: t("categories.create.success")
    else
      flash.now[:alert] = t("categories.create.failure")
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])
    if @category.update(category_params)
      redirect_to categories_path, notice: t("categories.update.success")
    else
      flash.now[:alert] = t("categories.update.failure")
      render :edit
    end
  end

  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    redirect_to categories_path, notice: t("categories.destroy.success")
  end

  private

  def category_params
    params.require(:category).permit(:name, :description)
  end
end
