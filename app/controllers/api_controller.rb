class ApiController < ApplicationController
  before_filter :authenticate
  skip_before_filter :verify_authenticity_token

  private

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      u = ENV['MOMMA_API_USER']
      p = ENV['MOMMA_API_PASSWORD']

      username == u && password == p
    end
  end
end
