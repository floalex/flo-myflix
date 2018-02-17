# for public API, you want to provide version instead of breaking other users' codes
class Api::V1::VideosController < ApiController
  before_action :require_user
  
  def show
    @video = VideoDecorator.decorate(Video.find(params[:id]))
  end
  
end