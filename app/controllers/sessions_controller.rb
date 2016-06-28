class SessionsController < ApplicationController
  def new
  end
  def create
  	@user = User.find_by(email: params[:session][:email].downcase)
  	if @user && @user.authenticate(params[:session][:password])
  		if @user.activated?
        log_in @user
        params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
    		redirect_back_or @user
      else
        message = "Account not activated. "
        message +="Please check your email inbox for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
  	else
  		#flash[:danger] = 'Invalid email/password' contents for flash remain for one request. but the render is not counted as a request, the flash notice persits until a request i.e clicking on the Home page link is made
  		flash.now[:danger] = 'Invalid email/password' #contents of flash disappear when an additional request is made
  		render 'new'
  	end
  end
  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
