class UsersController < ApplicationController
  
  def index
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
      flash[:success] = "Welcome to the Sample App"  #flashing the success message of signing up 
      redirect_to @user   # shortcut to write user_url(@user) => which means /users/.:id in html
    else
      render 'new'
    end

  end

  def update
  end

  def destroy
  end
  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmatio)
    end      
end
