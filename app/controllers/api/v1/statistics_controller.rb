# frozen_string_literal: true

module Api
  module V1
    # API endpoints for analytics data
    class StatisticsController < ApiController
      before_action :authenticate_user!

      # GET /api/v1/statistics
      def index
        render json: {
          overview: overview_stats,
          trends: trend_stats,
          performance: performance_stats
        }
      end

      private

      def overview_stats
        {
          total_tips: StartupTip.count,
          total_videos: Video.count,
          tips_with_videos: Video.distinct.count(:startup_tip_id),
          uploaded_videos: Video.where.not(youtube_url: nil).count,
          average_sentiment: StartupTip.average(:sentiment_score)&.round(2) || 0
        }
      end

      def trend_stats
        {
          tips_by_day: tips_by_day,
          videos_by_day: videos_by_day,
          sentiment_by_day: sentiment_by_day
        }
      end

      def performance_stats
        {
          processing_time: average_processing_times,
          success_rate: success_rates,
          error_distribution: error_distribution
        }
      end

      def tips_by_day
        StartupTip.group_by_day(:created_at, last: 30)
                 .count
      end

      def videos_by_day
        Video.group_by_day(:created_at, last: 30)
             .count
      end

      def sentiment_by_day
        StartupTip.group_by_day(:created_at, last: 30)
                 .average(:sentiment_score)
      end

      def average_processing_times
        {
          analysis: average_job_time(AnalyzeStartupTipsJob),
          script_generation: average_job_time(GenerateScriptJob),
          video_production: average_job_time(ProduceVideoJob),
          upload: average_job_time(UploadVideoJob)
        }
      end

      def success_rates
        {
          analysis: job_success_rate(AnalyzeStartupTipsJob),
          script_generation: job_success_rate(GenerateScriptJob),
          video_production: job_success_rate(ProduceVideoJob),
          upload: job_success_rate(UploadVideoJob)
        }
      end

      def error_distribution
        Video.where.not(error_message: nil)
             .group(:error_message)
             .count
      end

      def average_job_time(job_class)
        jobs = job_class.where.not(completed_at: nil)
        return 0 if jobs.empty?

        jobs.average('EXTRACT(EPOCH FROM (completed_at - started_at))')&.round(2) || 0
      end

      def job_success_rate(job_class)
        total = job_class.count
        return 0 if total.zero?

        success = job_class.where(status: 'completed').count
        ((success.to_f / total) * 100).round(2)
      end
    end
  end
end 