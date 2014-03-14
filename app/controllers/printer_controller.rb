class PrinterController < ApplicationController
  before_filter :authenticate_user!

  def update
    session[:printer] = params[:printer]

    render text: 'Printer Updated'
  end
end
