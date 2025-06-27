require 'httparty'

class VideoProducer
  def produce(video)
    script = video.script
    startup_tip = video.startup_tip

    # Generate TTS
    system("gtts-cli '#{script}' --lang en --output tmp/audio.mp3")

    # Download stock video from Pexels
    response = HTTParty.get(
      'https://api.pexels.com/videos/search?query=startup+tech&per_page=1',
      headers: { 'Authorization' => ENV['PEXELS_API_KEY'] }
    )
    video_url = response['videos'].first['video_files'].first['link']
    system("curl -o tmp/stock_video.mp4 '#{video_url}'")

    # Generate video with MoviePy (including chart)
    python_script = <<~PYTHON
      from moviepy.editor import VideoFileClip, TextClip, CompositeVideoClip, AudioFileClip
      from moviepy.editor import ColorClip
      video = VideoFileClip("tmp/stock_video.mp4").subclip(0, 45)
      audio = AudioFileClip("tmp/audio.mp3")
      text = TextClip("#{script}", fontsize=50, color='white', size=(1080, 1920)).set_duration(45)
      chart = ColorClip(size=(1080, 300), color=(255, 165, 0)).set_duration(15).set_position(('center', 100))
      final = CompositeVideoClip([video, text.set_pos('center'), chart.set_pos('bottom')]).set_audio(audio)
      final.write_videofile("public/videos/#{video.id}_final.mp4", fps=24)
      video.save_frame("public/thumbnails/#{video.id}_thumb.png", t=1)
    PYTHON
    File.write('tmp/generate_video.py', python_script)
    system('python tmp/generate_video.py')

    # Update video record
    video.update!(
      video_path: "public/videos/#{video.id}_final.mp4",
      thumbnail_path: "public/thumbnails/#{video.id}_thumb.png",
      status: 'produced'
    )
  rescue StandardError => e
    video.update!(status: 'failed')
    Rails.logger.error("Video production failed: #{e.message}")
  end
end 