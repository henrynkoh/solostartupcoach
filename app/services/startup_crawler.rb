require 'nokogiri'
require 'httparty'

class StartupCrawler
  def crawl
    startup_tips = crawl_tech_news_and_tools
    startup_tips.each do |tip|
      StartupTip.create!(
        topic: tip[:topic],
        tool: tip[:tool],
        source_url: tip[:source_url]
      ) unless StartupTip.exists?(topic: tip[:topic])
    end
  rescue StandardError => e
    Rails.logger.error("Startup crawling failed: #{e.message}")
  end

  private

  def crawl_tech_news_and_tools
    # Placeholder: Scrape TechCrunch, n8n docs, NewsAPI
    # Simulated data for MVP
    [
      {
        topic: 'AI Automation',
        tool: 'n8n',
        source_url: 'https://n8n.io'
      },
      {
        topic: 'LLM Content Creation',
        tool: 'ChatGPT',
        source_url: 'https://www.techcrunch.com'
      }
    ]
  end
end 