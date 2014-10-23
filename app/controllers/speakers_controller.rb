# -*- coding: utf-8 -*-
class SpeakersController < ApplicationController
  layout 'speaker'

  before_filter do
    unless @speaker = Query[:page_to_speaker_map][params[:name]]
      raise ActionController::RoutingError.new('Not Found')
    end
  end 

  after_filter do
    response.body = response.body.gsub('<articles>') do       
      articles = @speaker.articles.map do |title, url| 
        %Q{<li><a href="#{url}">#{title}</a></li>}
      end.join
      name_parent = Petrovich.new.firstname(@speaker.name.split.first, :genitive)
      %Q{<p class="speaker_articles"><h5>Знакомьтесь с материалами #{name_parent} на Websarafan.ru:</h5><ul>#{articles}</ul></p>}
    end
  end

  def show
    render params[:name]
  end
end
