class HomeController < ApplicationController
  def index
    redirect_to current_user.start_path if current_user
  end

end
