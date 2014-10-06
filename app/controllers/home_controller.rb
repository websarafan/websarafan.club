# -*- coding: utf-8 -*-
class HomeController < ApplicationController
  layout 'content'

  def pay
    render layout: 'application'
  end
end
