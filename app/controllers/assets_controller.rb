# -*- coding: utf-8 -*-
class AssetsController < ApplicationController
  before_filter :authenticate
  layout 'content'

  def say_it
    render inline: "<h1>#{Query[:signature, params[:username]]}</h1>"
  end

  protected

  def signature
    Context.username = username
    Query[:signature]
  end

  def authenticate
    authenticate_or_request_with_http_basic('Protected') do |username, password|
      Query[:signature, username] == password
    end 
  end
end
