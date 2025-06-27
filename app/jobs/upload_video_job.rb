class UploadVideoJob < ApplicationJob
  queue_as :default

  def perform(video_id)
    video = Video.find(video_id)
    YouTubeUploader.new.upload(video)
  end
end 