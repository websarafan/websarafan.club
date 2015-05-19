class YmController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def receiver
    Query[:process_notification!, params]
    if params[:withdraw_amount].to_i > 3000
      Mailer.confirmation(params[:email], I18n.t('notifications.payment_received.live.subject'), I18n.t('notifications.payment_received.live.body')).deliver_later
    elsif params[:withdraw_amount].to_i > 2000
      Mailer.confirmation(params[:email], I18n.t('notifications.payment_received.records.subject'), I18n.t('notifications.payment_received.records.body')).deliver_later
    elsif params[:withdraw_amount].to_i == 200
      Mailer.confirmation(params[:email], I18n.t('notifications.payment_received.fb_sales.subject'), I18n.t('notifications.payment_received.fb_sales.body')).deliver_later
    elsif (x = params[:withdraw_amount].to_i) && [1, 199].include?(x)
      Mailer.confirmation(params[:email], I18n.t('notifications.payment_received.finance.subject'), I18n.t('notifications.payment_received.finance.body')).deliver_later
    end
    head :ok
  end
end
