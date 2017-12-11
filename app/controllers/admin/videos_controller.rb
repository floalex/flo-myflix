class Admin::VideosController < ApplicationController
  before_action :require_user
  before_action :require_admin
  
  def new
    @video = Video.new
  end
  
  def create
    @video = Video.new(video_params)
    if @video.save
      flash[:success] = "You have successfully added #{@video.title}"
      redirect_to new_admin_video_path
    else
      flash[:danger] = "Something went wrong, please try agin."
      render :new
    end
  end
  
  private
  
  def require_admin
    if !current_user.admin?
      flash[:danger] = "You have to be an admin to do it"
      redirect_to home_path 
    end
  end
  
  def video_params
    params.require(:video).permit(:title, :category_id, :description, :small_cover, :large_cover, :video_url)
  end
end