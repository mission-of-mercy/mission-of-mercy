# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  before_filter :find_users, :only => [:new, :create]
  
  def new
    
  end

  def create
    logout_keeping_session!
    user = User.authenticate(params[:login], params[:password])
    if user
      # Protects against session fixation attacks, causes request forgery
      # protection if user resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset_session
      self.current_user = user

      redirect_to user.start_path
      #flash[:notice] = "Logged in successfully"
    else
      flash[:error] = "Couldn't log you in as '#{User.find_by_login(params[:login]).name}'"
      
      render :action => 'new'
    end
  end

  def destroy
    logout_killing_session!
    flash[:notice] = "You have been logged out."
    redirect_back_or_default('/')
  end

  private
  
  def find_users
    @users = User.all.reject {|u| u.name[/admin/i] }.
      map {|u| [u.name, u.login]}
  end
end
