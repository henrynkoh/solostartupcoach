# frozen_string_literal: true

# Job for uploading videos to YouTube
class UploadVideoJob < ApplicationJob
  queue_as :default
  retry_on StandardError, wait: :exponentially_longer, attempts: 3

  # Uploads a video to YouTube
  # @param video_id [Integer] the ID of the video to upload
  def perform(video_id)
    video = Video.find(video_id)
    
    # Skip if already uploaded
    return if video.youtube_url.present?

    # Skip if not ready for upload
    return unless video.ready_for_upload?

    YoutubeUploader.upload(video)

    # Clean up the local video file after successful upload
    cleanup_video_file(video)
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error("Video ##{video_id} not found: #{e.message}")
  rescue StandardError => e
    Rails.logger.error("Failed to upload Video ##{video_id}: #{e.message}")
    raise # Let retry mechanism handle it
  end

  private

  def cleanup_video_file(video)
    return unless video.file_path.present? && File.exist?(video.file_path)

    FileUtils.rm_f(video.file_path)
    video.update_column(:file_path, nil) # Skip callbacks and validations
  rescue StandardError => e
    Rails.logger.error("Failed to cleanup video file for Video ##{video.id}: #{e.message}")
    # Don't raise error here, as the upload was successful
  end
end
