class HomeController < ApplicationController
  before_filter :authenticate_user!

  def index
    redirect_to current_user.start_path if current_user
  end

end
