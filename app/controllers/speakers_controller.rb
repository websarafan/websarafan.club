class SpeakersController < ApplicationController
  layout 'content'
  SPEAKERS = I18n.t('speakers').map(&:first).map { |name| I18n.transliterate(name.split.join) }.freeze
  before_filter do
    unless SPEAKERS.include?(params[:name]) 
      raise ActionController::RoutingError.new('Not Found')
    end
  end 

  def show
    render params[:name]
  end
end
