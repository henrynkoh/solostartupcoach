class ErrorsController < ApplicationController
  skip_before_action :authenticate_user!

  def not_found
    respond_to do |format|
      format.html { render status: :not_found }
      format.json { render json: { error: 'Not found' }, status: :not_found }
    end
  end

  def unprocessable_entity
    respond_to do |format|
      format.html { render status: :unprocessable_entity }
      format.json { render json: { error: 'Unprocessable entity' }, status: :unprocessable_entity }
    end
  end

  def internal_server_error
    respond_to do |format|
      format.html { render status: :internal_server_error }
      format.json { render json: { error: 'Internal server error' }, status: :internal_server_error }
    end
  end

  def unauthorized
    respond_to do |format|
      format.html { render status: :unauthorized }
      format.json { render json: { error: 'Unauthorized' }, status: :unauthorized }
    end
  end

  def forbidden
    respond_to do |format|
      format.html { render status: :forbidden }
      format.json { render json: { error: 'Forbidden' }, status: :forbidden }
    end
  end
end
