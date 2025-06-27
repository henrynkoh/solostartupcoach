require 'google/apis/youtube_v3'

class YouTubeUploader
  def upload(video)
    youtube = Google::Apis::YoutubeV3::YouTubeService.new
    youtube.client_options.application_name = 'SoloStartupCoach'
    youtube.authorization = Google::Auth::ServiceAccountCredentials.make_creds(
      json_key_io: StringIO.new(ENV['GOOGLE_CREDENTIALS']),
      scope: 'https://www.googleapis.com/auth/youtube.upload'
    )

    video_snippet = Google::Apis::YoutubeV3::VideoSnippet.new(
      title: "#{video.startup_tip.topic}: Launch with #{video.startup_tip.tool}",
      description: "Solopreneur startup tips! #{video.startup_tip.strategy} Source: #{video.startup_tip.source_url}. Subscribe: youtube.com/@SoloStartupCoach\n*For informational purposes only.",
      tags: ['AI Startup', 'Solopreneur Tips', 'Entrepreneurship', 'Shorts'],
      category_id: '27' # Education
    )
    video_status = Google::Apis::YoutubeV3::VideoStatus.new(privacy_status: 'public')
    video_request = Google::Apis::YoutubeV3::Video.new(snippet: video_snippet, status: video_status)

    youtube.insert_video('snippet,status', video_request, upload_source: video.video_path) do |result, err|
      if err
        video.update!(status: 'failed')
        raise err
      else
        video.update!(youtube_id: result.id, status: 'uploaded')
      end
    end
  rescue StandardError => e
    video.update!(status: 'failed')
    Rails.logger.error("YouTube upload failed: #{e.message}")
  end
end 