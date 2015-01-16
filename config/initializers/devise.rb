# configuration options documented at https://github.com/plataformatec/devise
Devise.setup do |config|
  require 'devise/orm/active_record'
  config.mailer_sender = "noreply@migrationator.com"
  config.case_insensitive_keys = [ :email ]
  config.stretches = Rails.env.test? ? 1 : 10
  config.strip_whitespace_keys = [ :email ]
  config.skip_session_storage = [:http_auth]
  config.reconfirmable = true
  config.expire_all_remember_me_on_sign_out = true
  config.password_length = 8..128
  config.sign_out_via = :delete
  config.reset_password_within = 2.hours
end
