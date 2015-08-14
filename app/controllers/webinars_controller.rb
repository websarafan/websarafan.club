class WebinarsController < ApplicationController
  layout 'lean'

  def index
    @webinars = Query[:webinars]
  end

  def show
    @webinar = Query[:webinar, params[:id]]
  end
end
