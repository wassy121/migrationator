# configuration options documented at https://github.com/plataformatec/devise
Devise.setup do |config|
  require 'devise/orm/active_record'
  config.mailer_sender = "noreply@migrationator.com"
  config.case_insensitive_keys = [ :email ]
  config.stretches = 10
  config.pepper = "d0bfa35e81a136d386413a891488eec4ae8b3e3d8891562e608016bb1a43edaaeb2a4d66e2e7a807f79af1c47e887bf2b105f0a574f4c7bd552f902b87aafc51"
  config.use_salt_as_remember_token = true
  config.lock_strategy = :failed_attempts
  config.maximum_attempts = 5
  config.unlock_strategy = :both
  config.unlock_in = 2.hour
  config.reset_password_within = 2.hours
end
