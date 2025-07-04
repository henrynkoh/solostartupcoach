require 'fileutils'
require 'digest'
require 'marcel'

class SecureFileHandler
  ALLOWED_VIDEO_TYPES = ['video/mp4', 'video/quicktime'].freeze
  ALLOWED_IMAGE_TYPES = ['image/jpeg', 'image/png', 'image/webp'].freeze
  MAX_FILE_SIZE = 100.megabytes
  STORAGE_PATH = Rails.root.join('storage', 'secure').freeze

  class FileValidationError < StandardError; end
  class FileProcessingError < StandardError; end

  def self.save_video(video_file, metadata = {})
    validate_file!(video_file, ALLOWED_VIDEO_TYPES)
    store_file(video_file, 'videos', metadata)
  end

  def self.save_image(image_file, metadata = {})
    validate_file!(image_file, ALLOWED_IMAGE_TYPES)
    store_file(image_file, 'images', metadata)
  end

  def self.retrieve_file(filename)
    path = find_file(filename)
    raise FileValidationError, 'File not found' unless path && File.exist?(path)

    File.binread(path)
  end

  def self.validate_file!(file, allowed_types)
    mime_type = Marcel::MimeType.for(file)
    return if allowed_types.include?(mime_type)

    raise FileValidationError, "Invalid file type: #{mime_type}"
  end

  def self.store_file(file, type, metadata = {})
    validate_file!(file, allowed_types_for(type))

    filename = generate_secure_filename(file)
    path = storage_path_for(type, filename)

    store_with_metadata(file, path, metadata)
    path
  end

  def self.find_file(filename)
    Rails.root.glob("storage/**/#{filename}").first
  end

  def self.generate_secure_filename(file)
    original_name = file.original_filename
    extension = File.extname(original_name)
    basename = SecureRandom.uuid
    "#{basename}#{extension}"
  end

  class << self
    private

    def storage_path_for(type, filename)
      base_path = Rails.root.join('storage', type.to_s)
      FileUtils.mkdir_p(base_path)
      File.join(base_path, filename)
    end

    def store_with_metadata(file, path, metadata)
      File.open(path, 'wb', 0o600) do |f|
        f.write(file.read)
      end

      write_metadata(path, metadata) if metadata.present?
    end

    def write_metadata(file_path, metadata)
      metadata_path = "#{file_path}.meta.json"
      File.open(metadata_path, 'wb', 0o600) do |f|
        f.write(metadata.to_json)
      end
    end

    def allowed_types_for(type)
      case type
      when :image
        ['image/jpeg', 'image/png', 'image/gif']
      when :video
        ['video/mp4', 'video/quicktime']
      when :document
        ['application/pdf', 'application/msword',
         'application/vnd.openxmlformats-officedocument.wordprocessingml.document']
      else
        []
      end
    end
  end
end
