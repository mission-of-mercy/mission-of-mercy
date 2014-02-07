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
    @request = SupportRequest.new(support_request_params)

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
      @request.update_attributes(support_request_params)
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

  private

  def support_request_params
    params.require(:support_request).permit(:area_id, :treatment_area_id,
                                            :user_id)
  end
end
