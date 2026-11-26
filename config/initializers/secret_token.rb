token = ENV['SECRET_TOKEN']
if token.to_s.length < 30
  if Rails.env.production?
    raise 'Set SECRET_TOKEN to a random string of at least 30 characters.'
  else
    token = 'development-secret-token-change-me-0123456789'
  end
end

Registrame02::Application.config.secret_token = token
