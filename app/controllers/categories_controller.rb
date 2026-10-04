class CategoriesController < ApplicationController
  before_action :require_user, except: [ :index, :show ]
  before_action :set_category, only: [ :show, :edit, :update, :destroy ]

  def index
    @pagy, @categories = pagy(:offset, Category.includes(:articles).order(:name), limit: 10)
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      flash[:notice] = "Category was successfully created"
      redirect_to @category
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @articles = @category.articles.includes(:user).order(created_at: :desc)
  end

  def edit
  end

  def update
    if @category.update(category_params)
      flash[:notice] = "Category was successfully updated"
      redirect_to @category
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @category.destroy

    flash[:notice] = "Category was successfully deleted"
    redirect_to categories_path
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name)
  end
end
