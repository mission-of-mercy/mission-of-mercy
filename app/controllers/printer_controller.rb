class PrinterController < ApplicationController
  before_filter :authenticate_user!

  def update
    cookies.permanent[:printer] = params[:printer]
  end
end
