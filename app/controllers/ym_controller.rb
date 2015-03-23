class YmController < ApplicationController
  skip_before_filter :verify_authenticity_token
  
  def receiver
    Query[:process_notification!, params]
    if params[:withdraw_amount].to_i > 3000
      Mailer.confirmation(params[:email], I18n.t('notifications.payment_received.subject'), I18n.t('notifications.payment_received.vk_live')).deliver_later
    else
      Mailer.confirmation(params[:email], I18n.t('notifications.payment_received.subject'), I18n.t('notifications.payment_received.vk_records')).deliver_later
    end
    head :ok
  end
end
