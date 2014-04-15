class SupportRequestsController < ApplicationController
  def index
    @support_requests = pending_support_requests
  end

  def create
    @request = SupportRequest.create(
      user_id:           current_user.id,
      treatment_area_id: current_treatment_area.try(:id),
      ip_address:        request.remote_ip,
      resolved:          false
    )

    session[:current_support_request_id] = @request.id

    respond_to do |format|
      format.js
    end
  end

  def destroy
    @request = current_support_request

    if @request
      @request.resolved = true
      @request.save

      session[:current_support_request_id] = nil
    end

    respond_to do |format|
      format.js
    end
  end
end
