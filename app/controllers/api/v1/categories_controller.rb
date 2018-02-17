class Api::V1::CategoriesController < ApiController
  before_action :require_user
  
  def show
    @category = Category.find(params[:id])
  end
  
end