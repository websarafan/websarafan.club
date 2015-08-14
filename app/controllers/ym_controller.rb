class YmController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def receiver
    Query[:process_notification!, params]
    Mailer.confirmation(
                        params[:email],
                        I18n.t("notifications.payment_received.#{label}.subject"),
                        I18n.t("notifications.payment_received.#{label}.body")
                       ).deliver_later
    head :ok
  end

  protected

  def label
    @_label ||= params[:label].split(':').first
  end
end
