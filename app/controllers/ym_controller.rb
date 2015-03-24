class YmController < ApplicationController
  skip_before_filter :verify_authenticity_token
  
  def receiver
    Query[:process_notification!, params]
    if params[:withdraw_amount].to_i > 3000
      Mailer.confirmation(params[:email], I18n.t('notifications.payment_received.live.subject'), I18n.t('notifications.payment_received.live.body')).deliver_later
    else
      Mailer.confirmation(params[:email], I18n.t('notifications.payment_received.records.subject'), I18n.t('notifications.payment_received.records.body')).deliver_later
    end
    head :ok
  end
end