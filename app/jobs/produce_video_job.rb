# frozen_string_literal: true

# Job for producing videos
class ProduceVideoJob < ApplicationJob
  queue_as :default
  retry_on StandardError, wait: :exponentially_longer, attempts: 3

  # Produces a video from script data
  # @param script_data [Hash] the script data to produce a video from
  def perform(script_data)
    # Skip if script data is invalid
    return unless valid_script_data?(script_data)

    video = VideoProducer.produce_video(script_data)

    # If video production is successful, queue upload
    UploadVideoJob.perform_later(video.id) if video.file_path.present?
  rescue StandardError => e
    Rails.logger.error("Failed to produce video: #{e.message}")
    raise # Let retry mechanism handle it
  end

  private

  def valid_script_data?(script_data)
    return false unless script_data.is_a?(Hash)
    
    required_keys = %i[title description script_content]
    required_keys.all? { |key| script_data[key].present? }
  end
end
