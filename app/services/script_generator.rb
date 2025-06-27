class ScriptGenerator
  def generate(startup_tip)
    script = "#{startup_tip.topic}: #{startup_tip.strategy} #{startup_tip.case_study} Subscribe! *Consult a professional."
    startup_tip.videos.create!(script: script, status: 'pending')
  rescue StandardError => e
    Rails.logger.error("Script generation failed: #{e.message}")
  end
end 