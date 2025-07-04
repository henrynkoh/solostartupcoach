# frozen_string_literal: true

require 'google/apis/youtube_v3'

# Service for uploading videos to YouTube
class YoutubeUploader
  class Error < StandardError; end
  class APIError < Error; end
  class ValidationError < Error; end

  # Uploads a video to YouTube
  # @param video [Video] the video to upload
  # @return [String] the YouTube URL
  # @raise [APIError] if the upload fails
  # @raise [ValidationError] if the video is invalid
  def self.upload(video)
    new.upload(video)
  end

  def upload(video)
    validate_video!(video)

    # Here you would integrate with the YouTube API
    # For now, we'll simulate an upload
    youtube_url = simulate_upload(video)
    
    video.update!(
      status: 'uploaded',
      youtube_url: youtube_url
    )

    youtube_url
  rescue StandardError => e
    video.mark_as_failed("Upload failed: #{e.message}")
    Rails.logger.error("Failed to upload video #{video.id} to YouTube: #{e.message}")
    raise APIError, "Failed to upload video: #{e.message}"
  end

  private

  def validate_video!(video)
    unless video.is_a?(Video) && video.persisted?
      raise ValidationError, 'Invalid video object'
    end

    unless video.ready_for_upload?
      raise ValidationError, 'Video is not ready for upload'
    end

    unless File.exist?(video.file_path)
      raise ValidationError, 'Video file does not exist'
    end
  end

  def simulate_upload(video)
    # Simulate API delay
    sleep(1)

    # Generate a fake YouTube URL
    video_id = SecureRandom.alphanumeric(11)
    "https://youtube.com/watch?v=#{video_id}"
  end

  def youtube_client
    # Here you would initialize the YouTube API client
    # This would typically use OAuth2 credentials
    raise NotImplementedError, 'YouTube API integration not implemented'
  end

  def initialize_youtube_client
    client = Google::Apis::YoutubeV3::YouTubeService.new
    client.authorization = Google::Auth::ServiceAccountCredentials.make_creds(
      json_key_io: StringIO.new(ENV.fetch('GOOGLE_CREDENTIALS', nil)),
      scope: ['https://www.googleapis.com/auth/youtube.upload']
    )
    client
  end

  def build_video_metadata(video)
    {
      snippet: {
        title: video.startup_tip.topic,
        description: build_description(video),
        tags: %w[startup business entrepreneurship]
      },
      status: {
        privacyStatus: 'public',
        selfDeclaredMadeForKids: false
      }
    }
  end

  def upload_to_youtube(client, video, metadata)
    response = client.insert_video('snippet,status', metadata, upload_source: video.file_path)
    video.update!(youtube_id: response.id, status: 'published')
  rescue Google::Apis::Error => e
    handle_upload_error(video, e)
  end

  def handle_upload_error(video, error)
    video.update!(status: 'failed')
    Rails.logger.error("YouTube upload failed: #{error.message}")
    raise
  end

  def build_description(video)
    [
      'Solopreneur startup tips!',
      video.startup_tip.strategy,
      "Source: #{video.startup_tip.source_url}",
      'Subscribe: youtube.com/@SoloStartupCoach',
      '*For informational purposes only.'
    ].join(' ')
  end
end
