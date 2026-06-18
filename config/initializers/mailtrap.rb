require "mailtrap"

# Production: use Mailtrap Sending API (requires a verified sending domain)
if Rails.env.production? && ENV["MAILTRAP_API_KEY"].present?
  Rails.application.config.action_mailer.delivery_method = :mailtrap
  Rails.application.config.action_mailer.mailtrap_settings = {
    api_key: ENV["MAILTRAP_API_KEY"]
  }
end
