# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'Weshop@gmail.com'
  layout 'mailer'
end
