# frozen_string_literal: true

# Service for generating video scripts from startup tips
class ScriptGenerator
  class Error < StandardError; end
  class APIError < Error; end

  # Generates a video script from a startup tip
  # @param startup_tip [StartupTip] the startup tip to generate a script from
  # @return [Hash] the generated script data
  # @raise [APIError] if the API request fails
  def self.generate_script(startup_tip)
    new.generate_script(startup_tip)
  end

  def generate_script(startup_tip)
    raise ArgumentError, 'StartupTip must be provided' unless startup_tip.is_a?(StartupTip)
    raise ArgumentError, 'StartupTip content must be present' if startup_tip.content.blank?

    # Here you would integrate with an AI service for script generation
    # For now, we'll use a template-based approach
    {
      title: generate_title(startup_tip),
      description: generate_description(startup_tip),
      script_content: generate_content(startup_tip)
    }
  rescue StandardError => e
    Rails.logger.error("Failed to generate script for StartupTip##{startup_tip.id}: #{e.message}")
    raise APIError, "Failed to generate script: #{e.message}"
  end

  private

  def generate_title(startup_tip)
    "How to #{startup_tip.title}"
  end

  def generate_description(startup_tip)
    <<~DESCRIPTION
      Learn about #{startup_tip.title}. This video covers:
      - Key concepts and principles
      - Practical implementation steps
      - Real-world examples and case studies
      
      Based on expert advice and proven strategies.
    DESCRIPTION
  end

  def generate_content(startup_tip)
    <<~SCRIPT
      Hi everyone! Welcome to another startup tips video.
      
      Today, we're going to talk about #{startup_tip.title}.
      
      #{startup_tip.content}
      
      Let's break this down into actionable steps:
      
      1. First, understand the basics
         - Research and gather information
         - Learn from existing examples
      
      2. Plan your implementation
         - Set clear goals and metrics
         - Create a timeline
      
      3. Execute and iterate
         - Start with small experiments
         - Measure results
         - Adjust based on feedback
      
      Remember: Success comes from consistent effort and learning from both wins and failures.
      
      If you found this video helpful, don't forget to like and subscribe for more startup tips!
      
      Thanks for watching!
    SCRIPT
  end
end
