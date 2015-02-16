# -*- coding: utf-8 -*-
class HomeController < ApplicationController
  layout 'content'

  after_filter :gen_speaker_links, only: :schedule
  before_filter :init_order, only: [:pay, :pay_adv]

  def pay
    render layout: 'application'
  end

  def privacy
    render layout: 'application'
  end

  def welcome
    render layout: 'application'
  end

  def pay_adv
    render layout: 'application'
  end

  def marketing
    Context.landing = 'marketing'
    @partner_code = params[:code]
    render layout: 'newtemplate'
  end

  def entrepreneurs
    Context.landing = 'entrepreneurs'
    render layout: false
  end

  def redesign
    render layout: 'lean'
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

  def init_order
    Context.promocode = params[:promocode]
    @product = params[:product].to_sym
    @partner_code = params[:code]

    @sum, @account, @discount =\
    if @debug = params[:debug]
      [1, '41001771813399']
    elsif priceline = Query[:price, @product]
      [priceline[:amount], '41001832385608', priceline[:discount]]
    else
      render 'sorry'
    end
  end
end
