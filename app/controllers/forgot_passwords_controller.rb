class ForgotPasswordsController < ApplicationController
  def create
    user = User.find_by(email: params[:email])
    
    if user
      AppMailer.delay.send_forgot_password(user)
      redirect_to forgot_password_confimration_path
    else
      flash[:danger] = params[:email].blank? ? "Email can't be blank" : "Please enter the correct email"
      redirect_to forgot_password_path
    end
  end
end