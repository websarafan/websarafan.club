class SpeakersController < ApplicationController
  layout 'speaker'

  before_filter do
    unless @name = Query[:speakers_page_to_name][params[:name]]
      raise ActionController::RoutingError.new('Not Found')
    end
  end 

  def show
    @photo = "speakers/#{@name.split.join}.jpg"
    render params[:name]
  end
end
