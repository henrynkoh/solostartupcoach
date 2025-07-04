# frozen_string_literal: true

# Base API controller with shared functionality
class ApiController < ApplicationController
  include ApiSecurity
  skip_before_action :verify_authenticity_token
  skip_before_action :authenticate_user!

  # Return JSON responses
  respond_to :json

  # Handle common errors
  rescue_from StandardError, with: :handle_error
  rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :handle_validation_error

  def generate_script
    startup_tip = StartupTip.find(params[:startup_tip_id])

    # Validate input
    unless startup_tip.valid?
      return render json: { error: startup_tip.errors.full_messages },
                    status: :unprocessable_entity
    end

    # Use background job for processing
    job_id = GenerateScriptJob.perform_later(startup_tip.id)

    render json: {
      message: 'Script generation started',
      job_id: job_id,
      status_url: api_job_status_path(job_id)
    }
  rescue StandardError => e
    handle_error(e)
  end

  def job_status
    job = ActiveJob::Status.get(params[:job_id])

    if job.nil?
      render json: { error: 'Job not found' }, status: :not_found
    else
      render json: {
        status: job.status,
        progress: job.progress,
        errors: job.errors
      }
    end
  end

  private

  def handle_error(error)
    Rails.logger.error("API Error: #{error.message}")
    Rails.logger.error(error.backtrace.join("\n"))

    render json: {
      error: 'Internal Server Error',
      message: error.message
    }, status: :internal_server_error
  end

  def handle_not_found(error)
    render json: {
      error: 'Not Found',
      message: error.message
    }, status: :not_found
  end

  def handle_validation_error(error)
    render json: {
      error: 'Validation Error',
      message: error.message,
      errors: error.record.errors.full_messages
    }, status: :unprocessable_entity
  end

  def pagination_params
    {
      page: params.fetch(:page, 1),
      per_page: [
        params.fetch(:per_page, 25).to_i,
        100 # max per page
      ].min
    }
  end
end
