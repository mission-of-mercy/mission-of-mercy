class SupportRequestsController < ApplicationController
  before_filter :authenticate_user!, :except => [:active_requests]

  def active_requests
    respond_to do |format|
      format.json do
        @requests = SupportRequest.active

        requested = @requests.where(ip_address: request.remote_ip).first

        @requests.map! {|request| request.station_description }

        if requested
          request_id = requested.id
          @requests  = []
        end

        render :json => {
                          :requests       => @requests.join(" and "),
                          :help_requested => !!requested,
                          :request_id     => request_id
                        }.to_json
      end
    end
  end

  def create
    @request = SupportRequest.new(params[:support_request])

    @request.ip_address = request.remote_ip
    @request.resolved   = false

    @request = nil unless @request.save

    respond_to do |format|
      format.js
    end
  end

  def edit
    @request = SupportRequest.find(params[:id])
  end

  def update
    @request = SupportRequest.find(params[:id])

    if params[:support_request]
      @request.update_attributes(params[:support_request])
    else
      @request.resolved = true

      @request.save
    end

    respond_to do |format|
      format.html { redirect_to support_requests_path }
      format.js
    end
  end

  def destroy
    @request = SupportRequest.find(params[:id])

    @request.destroy

    redirect_to :action => 'index'
  end

end
