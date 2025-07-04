# frozen_string_literal: true

# Represents a video in the system, including its metadata and YouTube information.
#
# @!attribute [r] id
#   @return [Integer] The unique identifier for the video
# @!attribute title
#   @return [String] The title of the video
# @!attribute description
#   @return [String] The description of the video
# @!attribute file_path
#   @return [String] Path to the video file on disk
# @!attribute file_size
#   @return [Integer] Size of the video file in bytes
# @!attribute duration
#   @return [Integer] Duration of the video in seconds
# @!attribute status
#   @return [String] Current status of the video (processing/uploaded/failed)
# @!attribute youtube_url
#   @return [String, nil] The YouTube video URL after successful upload
# @!attribute created_at
#   @return [Time] When this record was created
# @!attribute updated_at
#   @return [Time] When this record was last updated
class Video < ApplicationRecord
  # Constants
  VALID_STATUSES = %w[processing uploaded failed].freeze
  MAX_FILE_SIZE = 100.megabytes
  VALID_URL_REGEX = URI::DEFAULT_PARSER.make_regexp(%w[http https])

  # Validations
  validates :title, presence: true
  validates :description, presence: true
  validates :file_path, presence: true
  validates :file_size, presence: true,
                       numericality: { 
                         less_than_or_equal_to: MAX_FILE_SIZE,
                         message: "must be less than #{MAX_FILE_SIZE} bytes"
                       }
  validates :duration, numericality: { 
                        greater_than: 0,
                        allow_nil: true
                      }
  validates :status, presence: true,
                    inclusion: { in: VALID_STATUSES }
  validates :youtube_url, format: { 
                           with: VALID_URL_REGEX,
                           message: 'is not a valid URL',
                           allow_blank: true
                         },
                         uniqueness: { 
                           allow_blank: true,
                           case_sensitive: false
                         }

  # Callbacks
  before_destroy :cleanup_file

  # Scopes
  scope :processing, -> { where(status: 'processing') }
  scope :uploaded, -> { where(status: 'uploaded') }
  scope :failed, -> { where(status: 'failed') }
  scope :recent, -> { order(created_at: :desc) }

  # @return [Boolean] whether the video is ready for upload
  def ready_for_upload?
    status == 'processing' && file_path.present? && File.exist?(file_path)
  end

  # @param new_status [String] the status to set
  # @return [Boolean] whether the status was successfully updated
  # @raise [ArgumentError] if the status is invalid
  def update_status(new_status)
    raise ArgumentError, "Invalid status: #{new_status}" unless VALID_STATUSES.include?(new_status)
    
    update(status: new_status)
  end

  # @param error_message [String] the error message to set
  # @return [Boolean] whether the video was marked as failed
  def mark_as_failed(error_message)
    return false unless error_message.is_a?(String)

    update(
      status: 'failed',
      error_details: error_message
    )
  end

  private

  # Cleans up the video file when record is destroyed
  # @return [void]
  def cleanup_file
    return unless file_path.present? && File.exist?(file_path)

    begin
      File.delete(file_path)
    rescue StandardError => e
      Rails.logger.error("Failed to delete file #{file_path}: #{e.message}")
    end
  end
end
