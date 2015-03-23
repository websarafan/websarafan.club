class YmController < ApplicationController
  skip_before_filter :verify_authenticity_token
  
  def receiver
    Query[:process_notification!, params]
    head :ok
  end
end
