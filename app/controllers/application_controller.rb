class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  before_action :check_email_confirmed!

  private

  def check_email_confirmed!
    if user_signed_in? && !current_user.confirmed?
      sign_out current_user
      redirect_to new_user_session_path, alert: "Please verify your email address before signing in."
    end
  end
end
