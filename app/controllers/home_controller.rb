class HomeController < ApplicationController
  before_filter :authenticate_user!
  def index
    ## needs to implement this feature later
    #redirect_to current_user.start_path if current_user && current_user.start_path != root_path
  end

end
