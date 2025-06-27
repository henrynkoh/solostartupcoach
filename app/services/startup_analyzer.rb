require 'httparty'

class StartupAnalyzer
  def analyze(startup_tip)
    strategy = generate_strategy(startup_tip.topic, startup_tip.tool)
    case_study = generate_case_study(startup_tip.tool)
    sentiment = analyze_sentiment(startup_tip.source_url)
    startup_tip.update!(
      strategy: strategy,
      case_study: case_study,
      sentiment: sentiment
    )
  rescue StandardError => e
    Rails.logger.error("Startup analysis failed: #{e.message}")
  end

  private

  def generate_strategy(topic, tool)
    # Simplified: Hardcoded strategies for MVP
    case topic
    when 'AI Automation'
      "Use #{tool} to automate workflows, save 10 hours/week."
    when 'LLM Content Creation'
      "Leverage #{tool} for marketing content, cut costs by 50%."
    else
      "Boost your startup with #{topic} using #{tool}."
    end
  end

  def generate_case_study(tool)
    # Simplified: Hypothetical cases
    case tool
    when 'n8n'
      "Solopreneur automates customer outreach, earns $10K/month."
    when 'ChatGPT'
      "Entrepreneur creates blog with LLM, saves $5K."
    else
      "#{tool} powers solopreneur success."
    end
  end

  def analyze_sentiment(source_url)
    response = HTTParty.get("https://newsapi.org/v2/everything?q=startup+#{URI.encode_www_form_component(source_url)}&apiKey=#{ENV['NEWSAPI_KEY']}", timeout: 10)
    content = response['articles']&.first&.[]('description') || ''
    keywords = { 'innovation' => 1, 'success' => 1, 'challenge' => -1, 'fail' => -1 }
    score = keywords.sum { |k, v| content.downcase.include?(k) ? v : 0 }
    score >= 0 ? 'positive' : 'negative'
  rescue
    'positive'
  end
end 