class Admin::UsersController < ApplicationController
  before_filter :admin_required
  before_filter :set_current_tab
  
  def index
    @users = User.find(:all)
  end

  def new
    @user = User.new
  end
 
  def create
    @user = User.new(params[:user])
    success = @user && @user.save
    if success && @user.errors.empty?
      redirect_to users_path
      flash[:notice] = "User Created"
    else
      flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
      render :action => 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
          flash[:notice] = 'User was successfully updated.'
          format.html { redirect_to(users_path) }
      end
    end
  end
  
  private
  
  def set_current_tab
    @current_tab = "users"
  end
end
