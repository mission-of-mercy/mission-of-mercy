class Admin::UsersController < ApplicationController
  before_filter :admin_required
  before_filter :set_current_tab

  def index
    @users = User.order(:login)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:notice] = "User Created"
      redirect_to admin_users_path
    else
      render :action => 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update_attributes(user_params)
      flash[:notice] = 'User was successfully updated.'
      redirect_to admin_users_path
    end
  end

  private

  def set_current_tab
    @current_tab = "users"
  end

  def user_params
    params.require(:user).permit!
  end
end
