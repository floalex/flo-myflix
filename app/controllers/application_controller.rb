class ApplicationController < ActionController::Base
  # run sudo service postgresql start before server
  
  protect_from_forgery with: :exception
  
  helper_method :current_user, :signed_in?
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  
  def signed_in?
    !!current_user
  end
  
  def require_user
    access_denied unless signed_in?
  end
  
  def access_denied
    flash[:warning] = "You must sign in or be an authorized user to see this page."
    redirect_to sign_in_path
  end
end
