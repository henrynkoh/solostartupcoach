module ApiSecurity
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_api_request!
    before_action :check_rate_limit!
    before_action :validate_content_type
    before_action :sanitize_parameters

    rescue_from StandardError, with: :handle_error
    rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found
    rescue_from ActionController::ParameterMissing, with: :handle_parameter_missing
  end

  private

  def authenticate_api_request!
    pattern = /^Bearer /
    header = request.headers['Authorization']
    return unauthorized_error unless header&.match(pattern)

    token = header.gsub(pattern, '')
    return unauthorized_error unless valid_token?(token)

    # Store token info for rate limiting
    Thread.current[:api_token] = token
  rescue StandardError
    unauthorized_error
  end

  def valid_token?(_token)
    # Implement your token validation logic here
    # Example: ApiToken.active.exists?(token: token)
    false
  end

  def check_rate_limit!
    key = "rate_limit:#{Thread.current[:api_token]}:#{Time.now.to_i / 60}"
    count = Rails.cache.increment(key, 1, expires_in: 1.minute)

    return unless count > max_requests_per_minute

    render json: {
      error: 'Rate limit exceeded',
      retry_after: (60 - (Time.now.to_i % 60))
    }, status: :too_many_requests
  end

  def max_requests_per_minute
    60 # Adjust based on your needs
  end

  def validate_content_type
    return unless request.post? || request.put? || request.patch?
    return if request.content_type == 'application/json'

    render json: { error: 'Content-Type must be application/json' },
           status: :unsupported_media_type
  end

  def sanitize_parameters
    params.each do |key, value|
      if value.is_a?(String)
        params[key] = sanitize_string(value)
      elsif value.is_a?(Hash)
        params[key] = sanitize_hash(value)
      end
    end
  end

  def sanitize_string(str)
    ActionController::Base.helpers.sanitize(str)
  end

  def sanitize_hash(hash)
    hash.transform_values do |value|
      if value.is_a?(String)
        sanitize_string(value)
      elsif value.is_a?(Hash)
        sanitize_hash(value)
      else
        value
      end
    end
  end

  def handle_error(error)
    Rails.logger.error("API Error: #{error.class} - #{error.message}")
    Rails.logger.error(error.backtrace.join("\n"))

    render json: {
      error: 'Internal server error',
      request_id: request.request_id
    }, status: :internal_server_error
  end

  def handle_not_found(_error)
    render json: { error: 'Resource not found' }, status: :not_found
  end

  def handle_parameter_missing(error)
    render json: {
      error: 'Missing required parameter',
      parameter: error.param
    }, status: :unprocessable_entity
  end

  def unauthorized_error
    render json: { error: 'Unauthorized' }, status: :unauthorized
  end
end
