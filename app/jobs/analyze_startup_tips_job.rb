class AnalyzeStartupTipsJob < ApplicationJob
  queue_as :default

  def perform(startup_tip_id)
    startup_tip = StartupTip.find(startup_tip_id)
    StartupAnalyzer.new.analyze(startup_tip)
    GenerateScriptJob.perform_later(startup_tip.id)
  end
end 