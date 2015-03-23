class YmController < ApplicationController
  def receiver
    Query[:process_notification!, params]
    head :ok
  end
end
