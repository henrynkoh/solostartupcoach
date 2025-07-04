# frozen_string_literal: true

module Api
  module V1
    # API endpoints for checking job status
    class JobStatusController < ApiController
      before_action :authenticate_user!

      # GET /api/v1/job_status/:jid
      def show
        job = Sidekiq::Status.get_all(params[:jid])
        
        if job.empty?
          render json: {
            error: 'Job not found',
            job_id: params[:jid]
          }, status: :not_found
        else
          render json: {
            job_id: params[:jid],
            status: job['status'],
            progress: job['progress'],
            error: job['error'],
            started_at: job['started_at'],
            completed_at: job['completed_at']
          }
        end
      end

      # GET /api/v1/job_status
      def index
        jobs = current_user.jobs.order(created_at: :desc)
                          .page(pagination_params[:page])
                          .per(pagination_params[:per_page])

        render json: {
          jobs: jobs.map { |job| job_status(job) },
          meta: {
            current_page: jobs.current_page,
            total_pages: jobs.total_pages,
            total_count: jobs.total_count
          }
        }
      end

      private

      def job_status(job)
        status = Sidekiq::Status.get_all(job.jid)
        
        {
          id: job.id,
          job_id: job.jid,
          job_class: job.job_class,
          args: job.args,
          status: status['status'] || 'unknown',
          progress: status['progress'],
          error: status['error'],
          created_at: job.created_at,
          started_at: status['started_at'],
          completed_at: status['completed_at']
        }
      end
    end
  end
end 