# frozen_string_literal: true

# Controller for the main dashboard
class DashboardController < ApplicationController
  before_action :authenticate_user!, except: :index

  # GET /
  def index
    @startup_tips = StartupTip.includes(:video)
                             .page(params[:page])
                             .per(10)
                             .order(created_at: :desc)

    @stats = {
      total_tips: StartupTip.count,
      total_videos: Video.count,
      tips_with_videos: Video.distinct.count(:startup_tip_id),
      uploaded_videos: Video.where.not(youtube_url: nil).count
    }

    respond_to do |format|
      format.html
      format.json do
        render json: {
          startup_tips: @startup_tips,
          stats: @stats,
          meta: {
            current_page: @startup_tips.current_page,
            total_pages: @startup_tips.total_pages,
            total_count: @startup_tips.total_count
          }
        }
      end
    end
  end

  def approve_video
    video = Video.find(params[:id])
    video.update!(status: 'approved')
    ProduceVideoJob.perform_later(video.id)
    redirect_to root_path, notice: 'Video approved for production.'
  end
end
