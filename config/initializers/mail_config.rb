def app_setting(env_key, config_key)
  if ENV.key?(env_key) && ENV[env_key].to_s != ""
    ENV[env_key]
  else
    APP_CONFIG[config_key]
  end
end

def app_boolean(env_key, config_key)
  raw = app_setting(env_key, config_key)
  return raw if raw == true || raw == false
  %w[1 true yes].include?(raw.to_s.downcase)
end

ActionMailer::Base.smtp_settings = {
  address: app_setting("MAIL_SERVER", "mail_server"),
  port: app_setting("MAIL_PORT", "mail_port").to_i,
  domain: app_setting("MAIL_DOMAIN", "host"),
  user_name: app_setting("MAIL_USERNAME", "mail_username"),
  password: app_setting("MAIL_PASSWORD", "mail_password"),
  authentication: app_setting("MAIL_AUTH", "mail_auth"),
  enable_starttls_auto: app_boolean("MAIL_STARTTLS", "mail_starttls")
}
