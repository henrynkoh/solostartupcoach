# frozen_string_literal: true

module Api
  module V1
    # API endpoints for managing videos
    class VideosController < ApiController
      before_action :set_video, only: %i[show update destroy]
      before_action :authenticate_user!, except: %i[index show]

      # GET /api/v1/videos
      def index
        @videos = Video.includes(:startup_tip)
                      .page(pagination_params[:page])
                      .per(pagination_params[:per_page])
                      .order(created_at: :desc)

        render json: {
          videos: @videos.as_json(include: :startup_tip),
          meta: {
            current_page: @videos.current_page,
            total_pages: @videos.total_pages,
            total_count: @videos.total_count
          }
        }
      end

      # GET /api/v1/videos/:id
      def show
        render json: @video.as_json(include: :startup_tip)
      end

      # POST /api/v1/videos/generate
      def generate
        startup_tip = StartupTip.find(params[:startup_tip_id])
        
        # Start the video generation pipeline
        AnalyzeStartupTipsJob.perform_later(startup_tip.id)

        render json: {
          message: 'Video generation started',
          startup_tip_id: startup_tip.id
        }, status: :accepted
      end

      # GET /api/v1/videos/:id/status
      def status
        video = Video.find(params[:id])
        
        render json: {
          id: video.id,
          status: video.status,
          youtube_url: video.youtube_url,
          error: video.error_message,
          progress: calculate_progress(video)
        }
      end

      private

      def set_video
        @video = Video.find(params[:id])
      end

      def calculate_progress(video)
        case video.status
        when 'processing'
          25
        when 'generated'
          50
        when 'uploading'
          75
        when 'uploaded'
          100
        else
          0
        end
      end
    end
  end
end 