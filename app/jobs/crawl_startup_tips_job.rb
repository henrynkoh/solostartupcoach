class CrawlStartupTipsJob < ApplicationJob
  queue_as :default

  def perform
    startup_tips = StartupCrawler.new.crawl
    startup_tips.each do |tip|
      AnalyzeStartupTipsJob.perform_later(StartupTip.find_by(topic: tip[:topic]).id)
    end
  end
end
