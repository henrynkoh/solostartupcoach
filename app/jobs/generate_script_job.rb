# frozen_string_literal: true

# Job for generating video scripts
class GenerateScriptJob < ApplicationJob
  queue_as :default
  retry_on StandardError, wait: :exponentially_longer, attempts: 3

  # Generates a script for a startup tip
  # @param startup_tip_id [Integer] the ID of the startup tip to generate a script for
  def perform(startup_tip_id)
    startup_tip = StartupTip.find(startup_tip_id)
    
    # Skip if already has a video
    return if startup_tip.video.present?

    script_data = ScriptGenerator.generate_script(startup_tip)

    # If script generation is successful, queue video production
    ProduceVideoJob.perform_later(script_data)
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error("StartupTip ##{startup_tip_id} not found: #{e.message}")
  rescue StandardError => e
    Rails.logger.error("Failed to generate script for StartupTip ##{startup_tip_id}: #{e.message}")
    raise # Let retry mechanism handle it
  end
end
