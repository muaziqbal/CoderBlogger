# https://github.com/thoughtbot/clearance
Clearance.configure do |config|
  config.cookie_domain = '.coderwall.com'
  config.httponly = false
  config.routes = false
  config.mailer_sender = "support@coderwall.com"
end
