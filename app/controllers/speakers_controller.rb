class SpeakersController < ApplicationController
  layout 'speaker'

  SPEAKERS = I18n.t('speakers').map(&:first).inject({}) do |res, name| 
    res[name] = I18n.transliterate(name.split.join); res  
  end.freeze

  before_filter do
    unless SPEAKERS.has_value?(params[:name]) 
      raise ActionController::RoutingError.new('Not Found')
    end
  end 

  def show
    @name = SPEAKERS.index(params[:name])
    @photo = "speakers/#{@name.split.join}.jpg"
    render params[:name]
  end
end
