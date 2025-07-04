# frozen_string_literal: true

# Service for producing videos from scripts
class VideoProducer
  class Error < StandardError; end
  class APIError < Error; end
  class ValidationError < Error; end

  # Produces a video from a script
  # @param script_data [Hash] the script data containing title, description, and content
  # @return [Video] the created video record
  # @raise [APIError] if the video production fails
  # @raise [ValidationError] if the script data is invalid
  def self.produce_video(script_data)
    new.produce_video(script_data)
  end

  def produce_video(script_data)
    validate_script_data!(script_data)

    Video.transaction do
      video = create_video_record(script_data)
      generate_video_file(video, script_data[:script_content])
      video
    end
  rescue StandardError => e
    Rails.logger.error("Failed to produce video: #{e.message}")
    raise APIError, "Failed to produce video: #{e.message}"
  end

  private

  def validate_script_data!(script_data)
    unless script_data.is_a?(Hash) &&
           script_data[:title].present? &&
           script_data[:description].present? &&
           script_data[:script_content].present?
      raise ValidationError, 'Invalid script data format'
    end
  end

  def create_video_record(script_data)
    Video.create!(
      title: script_data[:title],
      description: script_data[:description],
      file_path: generate_temp_path,
      file_size: 0, # Will be updated after generation
      status: 'processing'
    )
  end

  def generate_video_file(video, script_content)
    # Here you would integrate with a video generation service
    # For now, we'll create a dummy video file
    file_path = video.file_path
    FileUtils.mkdir_p(File.dirname(file_path))

    # Create a dummy video file
    File.open(file_path, 'wb') do |f|
      f.write('Dummy video content')
    end

    # Update video record with actual file size
    video.update!(
      file_size: File.size(file_path),
      duration: calculate_duration(script_content)
    )
  rescue StandardError => e
    # Clean up any created files
    FileUtils.rm_f(file_path) if file_path && File.exist?(file_path)
    raise
  end

  def generate_temp_path
    timestamp = Time.current.strftime('%Y%m%d%H%M%S')
    File.join(
      Rails.root,
      'tmp',
      'videos',
      "video_#{timestamp}_#{SecureRandom.hex(8)}.mp4"
    )
  end

  def calculate_duration(script_content)
    # Estimate video duration based on script length
    # Assuming average speaking speed of 150 words per minute
    words = script_content.split(/\s+/).size
    (words / 150.0 * 60).ceil
  end
end
