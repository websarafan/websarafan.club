# -*- coding: utf-8 -*-
class HomeController < ApplicationController
  layout 'content'

  after_filter :gen_speaker_links, only: :schedule
  before_filter :init_order, only: [:pay, :pay_adv]

  def pay
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
    render layout: false
  end

  def entrepreneurs
    Context.landing = 'entrepreneurs'
    render layout: false
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
    @sum, @account, @discount =\
    if @debug = params[:debug]
      [1, '41001771813399']
    else
      Context.promocode = params[:promocode]
      [Query[:price][:amount], '41001832385608', Query[:price][:discount]]
    end
  end
end
