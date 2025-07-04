# frozen_string_literal: true

# Represents a startup tip or advice.
#
# @!attribute [r] id
#   @return [Integer] The unique identifier for the startup tip
# @!attribute title
#   @return [String] The title of the tip
# @!attribute content
#   @return [String] The main content or advice
# @!attribute source_url
#   @return [String] URL of the source material
# @!attribute sentiment_score
#   @return [Float] The analyzed sentiment score (-1.0 to 1.0)
# @!attribute created_at
#   @return [Time] When this record was created
# @!attribute updated_at
#   @return [Time] When this record was last updated
class StartupTip < ApplicationRecord
  # Constants
  VALID_URL_REGEX = URI::DEFAULT_PARSER.make_regexp(%w[http https])

  # Validations
  validates :title, presence: true
  validates :content, presence: true
  validates :source_url, format: { 
                          with: VALID_URL_REGEX,
                          message: 'is not a valid URL',
                          allow_blank: true
                        }
  validates :sentiment_score, numericality: {
                              greater_than_or_equal_to: -1.0,
                              less_than_or_equal_to: 1.0,
                              allow_nil: true,
                              message: 'must be between -1 and 1'
                            }

  # Callbacks
  before_validation :sanitize_content
  before_validation :normalize_url

  # Scopes
  scope :recent, -> { order(created_at: :desc) }
  scope :positive, -> { where('sentiment_score > ?', 0) }
  scope :negative, -> { where('sentiment_score < ?', 0) }
  scope :neutral, -> { where('sentiment_score = ?', 0) }
  scope :unanalyzed, -> { where(sentiment_score: nil) }

  # @return [Boolean] whether this tip has been analyzed for sentiment
  def analyzed?
    sentiment_score.present?
  end

  # @param score [Float] the sentiment score to set
  # @return [Boolean] whether the sentiment score was successfully updated
  # @raise [ArgumentError] if the score is invalid
  def update_sentiment_score(score)
    raise ArgumentError, "Score must be between -1 and 1" unless score.nil? || (score >= -1.0 && score <= 1.0)
    
    update(sentiment_score: score)
  end

  private

  # Sanitizes the content before validation
  # @return [void]
  def sanitize_content
    return unless content_changed? && content.present?

    # First use Rails sanitizer to remove all HTML tags
    sanitized = ActionController::Base.helpers.sanitize(content, tags: [], attributes: [])
    
    # Then remove any remaining script content
    sanitized = sanitized.gsub(/alert\([^)]*\)/, '')
                        .gsub(/script/i, '')
                        .gsub(/javascript/i, '')
                        .strip
    
    self.content = sanitized
  end

  # Normalizes the URL before validation
  # @return [void]
  def normalize_url
    return if source_url.blank?

    begin
      uri = URI(source_url)
      uri.scheme = 'https' if uri.scheme == 'http'
      self.source_url = uri.to_s
    rescue URI::InvalidURIError => e
      errors.add(:source_url, "Invalid URL format: #{e.message}")
    end
  end
end
