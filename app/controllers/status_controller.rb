class StatusController < ApplicationController
  def index
    @requests = SupportRequest.find_all_by_resolved(false)
  end

end
