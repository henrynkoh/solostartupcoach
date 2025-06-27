class ProduceVideoJob < ApplicationJob
  queue_as :default

  def perform(video_id)
    video = Video.find(video_id)
    VideoProducer.new.produce(video)
    UploadVideoJob.perform_later(video.id) if video.status == 'produced'
  end
end 