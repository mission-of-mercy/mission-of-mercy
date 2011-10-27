class Admin::SupportRequestsController < ApplicationController
  before_filter :admin_required
  before_filter :find_support_request, :only => [:edit, :update, :destroy]
  before_filter :set_current_tab

  def index
    @requests = SupportRequest.all(:order => :resolved)
  end

  def edit

  end

  def update
    if @request.update_attributes(params[:support_request])
      redirect_to admin_support_requests_path
    else
      render :action => "edit"
    end
  end

  def destroy
    @request.destroy

    redirect_to admin_support_requests_path
  end

  def destroy_all
    SupportRequest.delete_all

    redirect_to admin_support_requests_path
  end

  private

  def find_support_request
    @request = SupportRequest.find(params[:id])
  end

  def set_current_tab
    @current_tab = "support-requests"
  end
end
