class ApplicationController < ActionController::Base
  # Basic security
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!
  before_action :set_security_headers

  # Only allow modern browsers
  allow_browser versions: :modern

  # Prevent timing attacks
  before_action :ensure_request_timing_safety

  rescue_from StandardError, with: :handle_error
  rescue_from ActionController::InvalidAuthenticityToken, with: :handle_invalid_authenticity_token
  rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found

  def index
    render 'application/index'
  end

  private

  def configure_permitted_parameters
    added_attrs = %i[username email password password_confirmation remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end

  def set_security_headers
    # Set additional security headers not covered by secure_headers gem
    response.headers['Permissions-Policy'] = 'geolocation=(), microphone=(), camera=()'
    response.headers['Cross-Origin-Embedder-Policy'] = 'require-corp'
    response.headers['Cross-Origin-Opener-Policy'] = 'same-origin'
    response.headers['Cross-Origin-Resource-Policy'] = 'same-origin'
  end

  def ensure_request_timing_safety
    # Add random delay to prevent timing attacks
    sleep(rand * 0.1)
  end

  def handle_error(error)
    Rails.logger.error("Application Error: #{error.class} - #{error.message}")
    Rails.logger.error(error.backtrace.join("\n"))

    respond_to do |format|
      format.html { render 'errors/internal_server_error', status: :internal_server_error }
      format.json { render json: { error: 'Internal server error' }, status: :internal_server_error }
    end
  end

  def handle_invalid_authenticity_token(_error)
    respond_to do |format|
      format.html { redirect_to root_path, alert: 'Invalid request token. Please try again.' }
      format.json { render json: { error: 'Invalid request token' }, status: :unprocessable_entity }
    end
  end

  def handle_not_found(_error)
    respond_to do |format|
      format.html { render 'errors/not_found', status: :not_found }
      format.json { render json: { error: 'Resource not found' }, status: :not_found }
    end
  end
end
