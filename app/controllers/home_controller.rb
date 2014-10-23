# -*- coding: utf-8 -*-
class HomeController < ApplicationController
  layout 'content'

  after_filter :gen_speaker_links, only: :schedule

  def pay
    @sum, @account =\
    if @debug = params[:debug]
      [1, '41001771813399']
    else
      [Query[:price][:amount], '41001832385608']
    end

    render layout: 'application'
  end

  protected 
  
  def gen_speaker_links
    link = -> (name) do
      %Q{<a href="#{Dictionary.gen_speaker_profile_link(name, self)}">#{name}</a>}
    end
    response.body = response.body.gsub(/^(\d\d\.\d\d.*)\ +\((.+)\)\s*$/) do 
      if Query[:speakers_names].include?($2)
        %Q{#{$1} (#{link.call($2)})}
      else
        %Q{#{$1} (#{$2})}
      end
    end
  end
end
