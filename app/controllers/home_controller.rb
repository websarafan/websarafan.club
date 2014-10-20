# -*- coding: utf-8 -*-
class HomeController < ApplicationController
  layout 'content'

  def pay
    render layout: 'application'
  end

  def speakers
    @speakers = I18n.t('speakers').map do |name, desc|
      name_aux = name.split.join
      [name, desc, "speakers/#{name_aux}.jpg", "/speakers/#{I18n.transliterate(name_aux)}"]
    end
  end
end
