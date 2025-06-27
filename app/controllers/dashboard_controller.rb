class DashboardController < ApplicationController
  def index
    @startup_tips = StartupTip.all
    @videos = Video.all
  end

  def approve_video
    video = Video.find(params[:id])
    video.update!(status: 'approved')
    ProduceVideoJob.perform_later(video.id)
    redirect_to root_path, notice: 'Video approved for production.'
  end
end 