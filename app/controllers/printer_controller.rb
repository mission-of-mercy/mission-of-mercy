class PrinterController < ApplicationController
  before_filter :authenticate_user!

  def update
    session[:printer] = params[:printer]
  end
end
