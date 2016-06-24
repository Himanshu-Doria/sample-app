class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index,:edit, :update]
  before_action :correct_user, only: [:edit, :update]
  def index
    @users = User.paginate(page: params[:page])
  end
  
  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
     
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcome to the Sample App"  #flashing the success message of signing up 
      redirect_to @user   # shortcut to write user_url(@user) => which means /users/.:id in html
    else
      render 'new'
    end

  end

  def update
    if @user.update_attributes(user_params)
      #Handle a successful edit
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
  end
  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmatio)
    end

    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "PLease log in first"  
        redirect_to login_url
      end
    end
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end        
end
