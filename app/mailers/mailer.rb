# -*- coding: utf-8 -*-
class Mailer < ApplicationMailer
  def confirmation(email, subject, body)
    mail(to: email, subject: subject, body: body)
  end
end
