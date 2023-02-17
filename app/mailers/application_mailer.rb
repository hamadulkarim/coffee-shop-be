class ApplicationMailer < ActionMailer::Base
  default from: 'Coffee Shop <shopkeeper@coffee.com>'

  layout 'mailer'
  prepend_view_path 'app/views/mailers'
end
