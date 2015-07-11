class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  before_filter :authenticate_user!, except: [:new, :create]

  respond_to :html, :json

  def index
     #Rails.logger.debug("index is: #{self.inspect}")
    @users = User.all
    respond_with(@users)
  end

  def show
    # Rails.logger.debug("show is: #{self.inspect}")
  end
  
  def edit
  end

  def new
    @user = User.new
  end
  def create
  
    @user = User.new(user_params)
   if @user.save
     sign_in @user
     redirect_to @user, {notice: 'Your account was created'}
   else
     render 'new'
   end

  end

  def update
    # required for settings form to submit when password is left blank
    if params[:user][:password].blank?
      params[:user].delete("password")
      params[:user].delete("password_confirmation")
    end
    if @user.update(user_params)
      
      # Sign in the user by passing validation in case his password changed
      sign_in :user, @user, :bypass => true 
      redirect_to @user, {notice: 'Your Account details were updated'}
    else
      render 'edit'
    end
  end

  def destroy
    @user.destroy
    redirect_to users_pth, {notice: 'Your account was deleted'}
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :password, :password_confirmation)
  end
end
