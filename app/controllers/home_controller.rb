# -*- coding: utf-8 -*-
class HomeController < ApplicationController
  layout 'content'

  def pay
    @sum, @account =\
    if @debug = params[:debug]
      [1, '41001771813399']
    else
      [4000, '41001832385608']
    end

    render layout: 'application'
  end

  def speakers
    @speakers = I18n.t('speakers').map do |name, desc|
      name_aux = name.split.join
      [name, desc, "speakers/#{name_aux}.jpg", "/speakers/#{I18n.transliterate(name_aux)}"]
    end
  end
end
