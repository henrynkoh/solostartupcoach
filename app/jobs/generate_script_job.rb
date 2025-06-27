class GenerateScriptJob < ApplicationJob
  queue_as :default

  def perform(startup_tip_id)
    startup_tip = StartupTip.find(startup_tip_id)
    video = ScriptGenerator.new.generate(startup_tip)
    ProduceVideoJob.perform_later(video.id)
  end
end 