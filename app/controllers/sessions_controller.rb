class SessionsController < ApplicationController
  before_filter :find_users, :only => [:new, :create]
  
  def new
    @last_user = cookies[:last_user]
  end

  def create
    logout_keeping_session!
    user = User.authenticate(params[:login], params[:password])
    if user
      self.current_user = user
      cookies[:last_user] = user.login
      
      flash.delete(:error)

      redirect_to user.start_path
    else
      flash[:error] = "Couldn't log you in as '#{User.find_by_login(params[:login]).name}'"
      
      render :action => 'new'
    end
  end

  def destroy
    stats.reset
    
    logout_killing_session!
    flash[:notice] = "You have been logged out."
    redirect_back_or_default('/')
  end

  private
  
  def find_users
    @users = User.all(:order => "login").map {|u| [u.name, u.login]}
  end
end
