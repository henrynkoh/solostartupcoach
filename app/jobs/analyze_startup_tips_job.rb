# frozen_string_literal: true

# Job for analyzing startup tips
class AnalyzeStartupTipsJob < ApplicationJob
  queue_as :default
  retry_on StandardError, wait: :exponentially_longer, attempts: 3

  # Analyzes a startup tip
  # @param startup_tip_id [Integer] the ID of the startup tip to analyze
  def perform(startup_tip_id)
    startup_tip = StartupTip.find(startup_tip_id)
    
    # Skip if already analyzed
    return if startup_tip.sentiment_score.present?

    StartupAnalyzer.analyze_sentiment(startup_tip)

    # If analysis is successful, queue script generation
    GenerateScriptJob.perform_later(startup_tip_id)
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error("StartupTip ##{startup_tip_id} not found: #{e.message}")
  rescue StandardError => e
    Rails.logger.error("Failed to analyze StartupTip ##{startup_tip_id}: #{e.message}")
    raise # Let retry mechanism handle it
  end
end
